import 'dart:async';

import 'package:flutter/material.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/ai_repository.dart';
import 'package:soma/data/exchange_analytics_repository.dart';
import 'package:soma/data/languages.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:soma/features/circles/exchange_session_controller.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class ExchangeSessionScreen extends StatefulWidget {
  final String partnerUserId;
  final String partnerName;
  final String myLearningLanguage;
  final String partnerLearningLanguage;

  const ExchangeSessionScreen({
    super.key,
    required this.partnerUserId,
    required this.partnerName,
    required this.myLearningLanguage,
    required this.partnerLearningLanguage,
  });

  @override
  State<ExchangeSessionScreen> createState() => _ExchangeSessionScreenState();
}

class _ExchangeSessionScreenState extends State<ExchangeSessionScreen> {
  final _input = TextEditingController();
  late final ExchangeSessionController _controller;
  Timer? _turnTicker;

  @override
  void initState() {
    super.initState();
    _controller = ExchangeSessionController(
      partnerName: widget.partnerName,
      partnerUserId: widget.partnerUserId,
      sessionKey: '${widget.partnerUserId}_${widget.myLearningLanguage}_${widget.partnerLearningLanguage}',
      firstLanguageCode: _normalizeCode(widget.myLearningLanguage),
      secondLanguageCode: _normalizeCode(widget.partnerLearningLanguage),
    )..hydrate();
    _track('exchange_discovery_impression');
    _track('session_opened');
    _controller.sendRequestIfNeeded().then((final sent) {
      if (sent) _track('conversation_request_sent');
    });
    _turnTicker = Timer.periodic(const Duration(seconds: 1), (final _) async {
      final skipped = await _controller.tickTurnAndAutoSkipIfNeeded();
      if (skipped) {
        await _track('turn_timeout_autoskip');
      }
    });
  }

  String _normalizeCode(final String raw) {
    return langCodeFromValue(raw) ?? 'en';
  }


  String _tr(final String en, {final String? fr, final String? es, final String? de}) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'fr') return fr ?? en;
    if (code == 'es') return es ?? en;
    if (code == 'de') return de ?? en;
    return en;
  }

  @override
  void dispose() {
    _turnTicker?.cancel();
    _input.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _track(final String event, {final Map<String, dynamic>? data}) {
    return exchangeAnalyticsRepository.track(event, metadata: {
      'partner_id': widget.partnerUserId,
      'partner_name': widget.partnerName,
      'active_lang': _controller.activeLanguageCode,
      ...?data,
    });
  }

  Future<void> _acceptRequest() async {
    await _controller.acceptRequest();
    await _track('conversation_request_accepted');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_tr('Conversation request accepted. You can start chatting now.', fr: 'Demande de conversation acceptée. Vous pouvez commencer à discuter.', es: 'Solicitud de conversación aceptada. Ya puedes empezar a chatear.', de: 'Konversationsanfrage akzeptiert. Du kannst jetzt chatten.'))),
    );
  }


  Future<void> _declineRequest() async {
    await _controller.declineRequest();
    await _track('conversation_request_declined');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_tr('Conversation request declined.', fr: 'Demande de conversation refusée.', es: 'Solicitud de conversación rechazada.', de: 'Konversationsanfrage abgelehnt.'))),
    );
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;

    if (!_controller.requestAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Accept conversation request before messaging.', fr: "Acceptez la demande de conversation avant d'envoyer un message.", es: 'Acepta la solicitud de conversación antes de enviar mensajes.', de: 'Akzeptiere die Konversationsanfrage, bevor du Nachrichten sendest.'))),
      );
      await _track('request_required_blocked_send');
      return;
    }

    if (!_controller.isMyTurn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Wait for your partner turn before sending.', fr: "Attendez le tour de votre partenaire avant d'envoyer.", es: 'Espera el turno de tu compañero antes de enviar.', de: 'Warte auf den Zug deines Partners, bevor du sendest.'))),
      );
      await _track('turn_blocked_send');
      return;
    }

    final ok = await _controller.sendMessage(text);
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message blocked: use ${_controller.activeLanguageCode.toUpperCase()} and keep within limits/cooldown (${_controller.cooldownSecondsRemaining}s).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      await _track('language_or_rate_lock_blocked');
      return;
    }

    await _track('message_sent_round_${_controller.round}');
    _input.clear();
  }

  Future<void> _markPartnerReply() async {
    await _controller.receivePartnerMessage('Thanks! Let us continue in ${_controller.activeLanguageCode.toUpperCase()}.');
    await _track('partner_reply_received');
  }

  Future<void> _skipTurn() async {
    await _controller.skipTurn();
    await _track('turn_skipped_manual');
  }

  Future<void> _suggestReply() async {
    final lang = _controller.activeLanguageCode;
    final options = lang == 'fr'
        ? ['Salut! Comment ça va ?', 'Je vais bien, merci.', 'Parlons de notre week-end.']
        : lang == 'es'
            ? ['Hola, ¿cómo estás?', 'Estoy bien, gracias.', '¿Qué hiciste hoy?']
            : lang == 'de'
                ? ['Hallo! Wie geht es dir?', 'Mir geht es gut, danke.', 'Was hast du heute gemacht?']
                : ['Hi! How are you?', 'I am doing well, thanks.', 'What did you do today?'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (final ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map((final o) => ListTile(
                    title: Text(o),
                    onTap: () => Navigator.pop(ctx, o),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null && mounted) {
      _input.text = selected;
      await _track('helper_suggest_reply');
    }
  }

  Future<void> _correctMySentence() async {
    final original = _input.text.trim();
    if (original.isEmpty) return;

    final allowed = await _controller.markCorrectionUsed();
    if (!context.mounted) return;
    if (!allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correction limit reached for this round (1 max).')),
      );
      return;
    }

    final corrected = original
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(' i ', ' I ')
        .trim();
    _input.text = corrected;
    await _track('helper_correct_sentence');

    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: const Text('Correction suggestion'),
        content: Text(
          'Original: $original\n'
          'Corrected: $corrected\n'
          'Why: normalized spacing/capitalization, improved readability, and simplified CEFR-friendly phrasing.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _translateDraft() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;

    if (text.length > 600) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Draft is too long to translate (max 600 characters).', fr: 'Le brouillon est trop long à traduire (600 caractères max).', es: 'El borrador es demasiado largo para traducir (máximo 600 caracteres).', de: 'Der Entwurf ist zu lang zum Übersetzen (max. 600 Zeichen).'))),
      );
      return;
    }

    final target = langNameFromCode(_controller.activeLanguageCode);
    try {
      final translated = await aiRepository.translateText(text, target);
      if (!mounted) return;
      _input.text = translated.trim();
      await _track('helper_translate_draft', data: {'target_language': target});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Draft translated to $target.', fr: 'Brouillon traduit en $target.', es: 'Borrador traducido a $target.', de: 'Entwurf in $target übersetzt.'))),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Could not translate draft right now. Please try again.', fr: 'Le brouillon ne peut pas être traduit pour le moment. Réessayez.', es: 'No se pudo traducir el borrador ahora mismo. Inténtalo de nuevo.', de: 'Der Entwurf konnte gerade nicht übersetzt werden. Bitte erneut versuchen.'))),
      );
    }
  }

  Future<void> _nextRound() async {
    if (_controller.round >= ExchangeSessionController.maxRounds) {
      _showSummary();
      return;
    }
    await _controller.nextRound();
    await _track('round_advanced_${_controller.round}');
  }

  Future<void> _showSummary() async {
    final minutes = DateTime.now().difference(_controller.startedAt).inMinutes;
    final activeWords = _controller.messages
        .where((final m) => m.languageCode == _controller.activeLanguageCode)
        .fold<int>(0, (final a, final b) => a + b.text.split(' ').length);
    final otherWords = _controller.messages
        .where((final m) => m.languageCode != _controller.activeLanguageCode)
        .fold<int>(0, (final a, final b) => a + b.text.split(' ').length);

    await _track('session_completed', data: {
      'active_words': activeWords,
      'other_words': otherWords,
      'duration_mins': minutes,
      'total_messages': _controller.messages.length,
      'corrections_used': _controller.myCorrectionsUsed,
    });

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final ctx) => AlertDialog(
        title: const Text('Session summary'),
        content: Text(
          '${_controller.activeLanguageCode.toUpperCase()} words: $activeWords\n'
          '${_controller.inactiveLanguageCode.toUpperCase()} words: $otherWords\n'
          'Corrections used: ${_controller.myCorrectionsUsed}\n'
          'Messages: ${_controller.messages.length}\n'
          'Duration: ${minutes}m\n'
          'Recommendation: review words from the weaker-language turns.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _track('review_weak_items_tap');
              if (!context.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tip: open Solo mode > Review to practice weak items.')));
            },
            child: const Text('Review weak items'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Exchange with ${widget.partnerName}'),
            const SizedBox(width: 8),
            StreamBuilder<bool>(
              stream: presenceRepository.streamOnlineStatus(widget.partnerUserId),
              builder: (final context, final snapshot) {
                final isOnline = snapshot.data ?? false;
                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF58F7B6) : Colors.grey,
                    shape: BoxShape.circle,
                    boxShadow: isOnline
                        ? [
                            BoxShadow(
                              color: const Color(0xFF58F7B6).withValues(alpha: 0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: _nextRound, child: const Text('Next round')),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (final context, final _) {
          final roundLabel = '${_controller.activeLanguageCode.toUpperCase()} round';
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Glass(
                  radius: BorderRadius.circular(14),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Round ${_controller.round}/${ExchangeSessionController.maxRounds} • $roundLabel',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Language lock • ${_controller.isMyTurn ? 'Your turn' : 'Partner turn'} • '
                        'Corrections left: ${ExchangeSessionController.maxCorrectionPerRound - _controller.myCorrectionsUsed} • '
                        'Turn timer: ${_controller.turnSecondsRemaining}s',
                      ),
                      const SizedBox(height: 4),
                      Text(_controller.requestAccepted
                          ? 'Conversation status: accepted'
                          : (_controller.requestStatus == 'declined'
                              ? 'Conversation status: declined'
                              : (_controller.requestStatus == 'expired'
                                  ? 'Conversation status: expired'
                                  : 'Conversation status: pending'))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _controller.messages.length,
                  itemBuilder: (final _, final i) {
                    final m = _controller.messages[i];
                    return Align(
                      alignment: m.from == 'You' ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: m.from == 'You'
                              ? const Color(0xFF2AFADF).withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${m.from}: ${m.text} (${m.languageCode.toUpperCase()})'),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _input,
                            decoration: InputDecoration(hintText: _tr('Type message...', fr: 'Saisissez un message...', es: 'Escribe un mensaje...', de: 'Nachricht eingeben...')),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 2,
                      children: [
                        if (_controller.requestStatus == 'pending') ...[
                          TextButton(onPressed: _acceptRequest, child: Text(_tr('Accept request', fr: 'Accepter', es: 'Aceptar', de: 'Annehmen'))),
                          TextButton(onPressed: _declineRequest, child: Text(_tr('Decline request', fr: 'Refuser', es: 'Rechazar', de: 'Ablehnen'))),
                        ] else if (_controller.requestStatus == 'accepted')
                          TextButton(onPressed: null, child: Text(_tr('Request accepted', fr: 'Demande acceptée', es: 'Solicitud aceptada', de: 'Anfrage akzeptiert')) )
                        else
                          TextButton(onPressed: null, child: Text(_tr('Request ${_controller.requestStatus}', fr: 'Demande ${_controller.requestStatus}', es: 'Solicitud ${_controller.requestStatus}', de: 'Anfrage ${_controller.requestStatus}'))),
                        TextButton(onPressed: _translateDraft, child: const Text('Translate')),
                        TextButton(onPressed: _suggestReply, child: const Text('Suggest reply')),
                        TextButton(onPressed: _correctMySentence, child: const Text('Correct me')),
                        TextButton(onPressed: _markPartnerReply, child: const Text('Partner replied')),
                        TextButton(onPressed: _skipTurn, child: const Text('Skip turn')),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.start,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
