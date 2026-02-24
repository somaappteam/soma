import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeMessage {
  final String from;
  final String text;
  final String languageCode;

  const ExchangeMessage({
    required this.from,
    required this.text,
    required this.languageCode,
  });

  Map<String, dynamic> toJson() => {
        'from': from,
        'text': text,
        'language_code': languageCode,
      };

  factory ExchangeMessage.fromJson(final Map<String, dynamic> json) {
    return ExchangeMessage(
      from: json['from']?.toString() ?? 'Unknown',
      text: json['text']?.toString() ?? '',
      languageCode: json['language_code']?.toString() ?? 'en',
    );
  }
}

class ExchangeSessionController extends ChangeNotifier {
  ExchangeSessionController({
    required this.partnerName,
    required this.partnerUserId,
    required this.sessionKey,
    required this.firstLanguageCode,
    required this.secondLanguageCode,
  });

  final String partnerName;
  final String partnerUserId;
  final String sessionKey;
  final String firstLanguageCode;
  final String secondLanguageCode;

  static const int maxRounds = 10;
  static const int maxCorrectionPerRound = 1;
  static const int maxMessagesPerMinute = 6;
  static const int maxMessagesPerSession = 80;
  static const Duration turnDuration = Duration(seconds: 45);
  static const Duration requestTtl = Duration(minutes: 10);

  final List<ExchangeMessage> _messages = [];
  final List<DateTime> _sentAt = [];

  List<ExchangeMessage> get messages => List.unmodifiable(_messages);

  int round = 1;
  String activeLanguageCode = 'en';
  int myCorrectionsUsed = 0;
  bool isMyTurn = true;
  String requestStatus = 'pending'; // pending | accepted | declined | expired
  DateTime startedAt = DateTime.now();
  DateTime requestCreatedAt = DateTime.now();
  DateTime _turnStartedAt = DateTime.now();
  DateTime? _cooldownUntil;
  static final Map<String, DateTime> _lastRequestByPartner =
      <String, DateTime>{};

  static const Map<String, Set<String>> _langHints = {
    'en': {
      'the',
      'is',
      'are',
      'thanks',
      'hello',
      'what',
      'where',
      'weekend',
      'today',
      'good'
    },
    'fr': {
      'bonjour',
      'salut',
      'merci',
      'oui',
      'non',
      'comment',
      'avec',
      'pour',
      'est',
      'suis'
    },
    'es': {'hola', 'gracias', 'donde', 'como', 'estoy', 'usted', 'por', 'que'},
    'de': {'hallo', 'danke', 'ich', 'du', 'nicht', 'und', 'wo', 'wie'},
  };

  String get inactiveLanguageCode => activeLanguageCode == firstLanguageCode
      ? secondLanguageCode
      : firstLanguageCode;

  bool get requestAccepted => requestStatus == 'accepted';

  bool get requestExpired =>
      DateTime.now().difference(requestCreatedAt) > requestTtl;

  int get turnSecondsRemaining {
    final elapsed = DateTime.now().difference(_turnStartedAt);
    final left = turnDuration.inSeconds - elapsed.inSeconds;
    return left < 0 ? 0 : left;
  }

  bool get isInCooldown =>
      _cooldownUntil != null && DateTime.now().isBefore(_cooldownUntil!);

  int get cooldownSecondsRemaining {
    if (_cooldownUntil == null) return 0;
    final secs = _cooldownUntil!.difference(DateTime.now()).inSeconds;
    return secs < 0 ? 0 : secs;
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('exchange_session_$sessionKey');
    activeLanguageCode = firstLanguageCode;
    if (raw == null || raw.isEmpty) {
      _turnStartedAt = DateTime.now();
      requestCreatedAt = DateTime.now();
      return;
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    round = (decoded['round'] as num?)?.toInt() ?? 1;
    activeLanguageCode =
        decoded['activeLanguageCode']?.toString() ?? firstLanguageCode;
    myCorrectionsUsed = (decoded['myCorrectionsUsed'] as num?)?.toInt() ?? 0;
    isMyTurn = decoded['isMyTurn'] == true;
    requestStatus = decoded['requestStatus']?.toString() ?? 'pending';
    final startedRaw = decoded['startedAt']?.toString();
    startedAt = DateTime.tryParse(startedRaw ?? '') ?? DateTime.now();
    final requestRaw = decoded['requestCreatedAt']?.toString();
    requestCreatedAt = DateTime.tryParse(requestRaw ?? '') ?? DateTime.now();
    final turnStartedRaw = decoded['turnStartedAt']?.toString();
    _turnStartedAt = DateTime.tryParse(turnStartedRaw ?? '') ?? DateTime.now();
    final cooldownRaw = decoded['cooldownUntil']?.toString();
    _cooldownUntil = DateTime.tryParse(cooldownRaw ?? '');
    _messages
      ..clear()
      ..addAll(((decoded['messages'] as List?) ?? const [])
          .whereType<Map>()
          .map((final e) =>
              ExchangeMessage.fromJson(Map<String, dynamic>.from(e))));

    if (requestStatus == 'pending' && requestExpired) {
      requestStatus = 'expired';
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'exchange_session_$sessionKey',
      jsonEncode({
        'round': round,
        'activeLanguageCode': activeLanguageCode,
        'myCorrectionsUsed': myCorrectionsUsed,
        'isMyTurn': isMyTurn,
        'requestStatus': requestStatus,
        'startedAt': startedAt.toIso8601String(),
        'requestCreatedAt': requestCreatedAt.toIso8601String(),
        'turnStartedAt': _turnStartedAt.toIso8601String(),
        'cooldownUntil': _cooldownUntil?.toIso8601String(),
        'messages': _messages.map((final m) => m.toJson()).toList(),
      }),
    );
  }

  Future<bool> sendRequestIfNeeded() async {
    if (requestStatus == 'accepted' || requestStatus == 'declined') {
      return false;
    }
    if (requestStatus == 'pending' && !requestExpired) return false;

    final now = DateTime.now();
    final last = _lastRequestByPartner[partnerUserId];
    if (last != null && now.difference(last) < const Duration(minutes: 1)) {
      return false;
    }

    requestStatus = 'pending';
    requestCreatedAt = now;
    _lastRequestByPartner[partnerUserId] = now;
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> acceptRequest() async {
    requestStatus = 'accepted';
    await _persist();
    notifyListeners();
  }

  Future<void> declineRequest() async {
    requestStatus = 'declined';
    await _persist();
    notifyListeners();
  }

  bool messageLooksValidForRound(final String text) {
    final value = text.toLowerCase().trim();
    if (value.isEmpty) return false;

    final hints = _langHints[activeLanguageCode];
    final tokens = value
        .split(RegExp(r"[^a-zA-ZÃ€-Ã¿']+"))
        .where((final t) => t.isNotEmpty)
        .toList();

    var charSignal = 0;
    if (activeLanguageCode == 'fr' &&
        RegExp(r'[Ã Ã¢Ã§Ã©Ã¨ÃªÃ«Ã®Ã¯Ã´Ã»Ã¹Ã¼Ã¿Å“]').hasMatch(value)) {
      charSignal++;
    }
    if (activeLanguageCode == 'es' &&
        RegExp(r'[Ã¡Ã©Ã­Ã³ÃºÃ±Â¿Â¡]').hasMatch(value)) {
      charSignal++;
    }
    if (activeLanguageCode == 'de' && RegExp(r'[Ã¤Ã¶Ã¼ÃŸ]').hasMatch(value)) {
      charSignal++;
    }

    if (hints == null || hints.isEmpty) {
      return charSignal > 0 || tokens.length >= 2;
    }

    final hitCount = tokens.where(hints.contains).length;
    if (tokens.length <= 2) return true;
    return (hitCount >= (tokens.length / 5).floor()) || charSignal > 0;
  }

  bool _withinRateLimit() {
    final now = DateTime.now();
    _sentAt.removeWhere(
        (final t) => now.difference(t) > const Duration(minutes: 1));
    return _sentAt.length < maxMessagesPerMinute;
  }

  Future<bool> sendMessage(final String text) async {
    if (requestStatus == 'pending' && requestExpired) {
      requestStatus = 'expired';
    }
    if (!requestAccepted) return false;
    final reportScore =
        (_messages.where((final m) => m.from == partnerName).length > 40)
            ? 1
            : 0;
    if (reportScore > 0) return false;
    if (!isMyTurn) return false;
    if (isInCooldown) return false;
    if (text.trim().length < 2) return false;
    if (_messages.length >= maxMessagesPerSession) return false;
    if (!_withinRateLimit()) {
      _cooldownUntil = DateTime.now().add(const Duration(seconds: 20));
      await _persist();
      notifyListeners();
      return false;
    }
    if (!messageLooksValidForRound(text)) return false;

    _messages.add(ExchangeMessage(
        from: 'You', text: text, languageCode: activeLanguageCode));
    _sentAt.add(DateTime.now());
    isMyTurn = false;
    _turnStartedAt = DateTime.now();
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> receivePartnerMessage(final String text) async {
    _messages.add(ExchangeMessage(
        from: partnerName, text: text, languageCode: activeLanguageCode));
    isMyTurn = true;
    _turnStartedAt = DateTime.now();
    await _persist();
    notifyListeners();
  }

  bool canUseCorrection() => myCorrectionsUsed < maxCorrectionPerRound;

  Future<bool> markCorrectionUsed() async {
    if (!canUseCorrection()) return false;
    myCorrectionsUsed += 1;
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> skipTurn() async {
    isMyTurn = false;
    _turnStartedAt = DateTime.now();
    await _persist();
    notifyListeners();
  }

  Future<bool> tickTurnAndAutoSkipIfNeeded() async {
    if (requestStatus == 'pending' && requestExpired) {
      requestStatus = 'expired';
      await _persist();
      notifyListeners();
      return false;
    }
    if (!isMyTurn) return false;
    if (turnSecondsRemaining > 0) return false;
    await skipTurn();
    return true;
  }

  Future<void> nextRound() async {
    if (round >= maxRounds) return;
    round += 1;
    activeLanguageCode = activeLanguageCode == firstLanguageCode
        ? secondLanguageCode
        : firstLanguageCode;
    myCorrectionsUsed = 0;
    isMyTurn = true;
    _turnStartedAt = DateTime.now();
    await _persist();
    notifyListeners();
  }
}
