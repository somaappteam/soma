import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ExchangeRoundLanguage { french, english }

class ExchangeMessage {
  final String from;
  final String text;
  final ExchangeRoundLanguage language;

  const ExchangeMessage({
    required this.from,
    required this.text,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
        'from': from,
        'text': text,
        'lang': language.name,
      };

  factory ExchangeMessage.fromJson(Map<String, dynamic> json) {
    return ExchangeMessage(
      from: json['from']?.toString() ?? 'Unknown',
      text: json['text']?.toString() ?? '',
      language: (json['lang']?.toString() == ExchangeRoundLanguage.english.name)
          ? ExchangeRoundLanguage.english
          : ExchangeRoundLanguage.french,
    );
  }
}

class ExchangeSessionController extends ChangeNotifier {
  ExchangeSessionController({
    required this.partnerName,
    required this.partnerUserId,
    required this.sessionKey,
  });

  final String partnerName;
  final String partnerUserId;
  final String sessionKey;
  static const int maxRounds = 10;

  final List<ExchangeMessage> _messages = [];
  List<ExchangeMessage> get messages => List.unmodifiable(_messages);

  int round = 1;
  ExchangeRoundLanguage activeLanguage = ExchangeRoundLanguage.french;
  int myCorrectionsUsed = 0;
  bool isMyTurn = true;
  DateTime startedAt = DateTime.now();

  static const _englishStop = {
    'the', 'is', 'are', 'thanks', 'hello', 'what', 'where', 'weekend', 'today', 'good'
  };
  static const _frenchStop = {
    'bonjour', 'salut', 'merci', 'oui', 'non', 'comment', 'avec', 'pour', 'est', 'suis'
  };

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('exchange_session_$sessionKey');
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    round = (decoded['round'] as num?)?.toInt() ?? 1;
    activeLanguage = (decoded['activeLanguage']?.toString() == ExchangeRoundLanguage.english.name)
        ? ExchangeRoundLanguage.english
        : ExchangeRoundLanguage.french;
    myCorrectionsUsed = (decoded['myCorrectionsUsed'] as num?)?.toInt() ?? 0;
    isMyTurn = decoded['isMyTurn'] == true;
    final startedRaw = decoded['startedAt']?.toString();
    startedAt = DateTime.tryParse(startedRaw ?? '') ?? DateTime.now();
    _messages
      ..clear()
      ..addAll(((decoded['messages'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => ExchangeMessage.fromJson(Map<String, dynamic>.from(e))));
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'exchange_session_$sessionKey',
      jsonEncode({
        'round': round,
        'activeLanguage': activeLanguage.name,
        'myCorrectionsUsed': myCorrectionsUsed,
        'isMyTurn': isMyTurn,
        'startedAt': startedAt.toIso8601String(),
        'messages': _messages.map((m) => m.toJson()).toList(),
      }),
    );
  }

  bool messageLooksValidForRound(String text) {
    final value = text.toLowerCase();
    final tokens = value.split(RegExp(r"[^a-zA-ZÀ-ÿ']+")).where((t) => t.isNotEmpty).toList();
    final englishHits = tokens.where(_englishStop.contains).length;
    final frenchHits = tokens.where(_frenchStop.contains).length;

    if (activeLanguage == ExchangeRoundLanguage.english) {
      if (RegExp(r'[àâçéèêëîïôûùüÿœ]').hasMatch(value)) return false;
      return englishHits >= frenchHits;
    }

    if (RegExp(r'\b(the|is|are|what|thanks|weekend)\b').hasMatch(value)) return false;
    return frenchHits >= englishHits;
  }

  Future<bool> sendMessage(String text) async {
    if (!isMyTurn) return false;
    if (!messageLooksValidForRound(text)) return false;
    _messages.add(ExchangeMessage(from: 'You', text: text, language: activeLanguage));
    isMyTurn = false;
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> receivePartnerMessage(String text) async {
    _messages.add(ExchangeMessage(from: partnerName, text: text, language: activeLanguage));
    isMyTurn = true;
    await _persist();
    notifyListeners();
  }

  bool canUseCorrection() => myCorrectionsUsed < 1;

  Future<bool> markCorrectionUsed() async {
    if (!canUseCorrection()) return false;
    myCorrectionsUsed += 1;
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> nextRound() async {
    if (round >= maxRounds) return;
    round += 1;
    activeLanguage = activeLanguage == ExchangeRoundLanguage.french
        ? ExchangeRoundLanguage.english
        : ExchangeRoundLanguage.french;
    myCorrectionsUsed = 0;
    isMyTurn = true;
    await _persist();
    notifyListeners();
  }
}
