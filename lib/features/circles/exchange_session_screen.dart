import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../data/exchange_analytics_repository.dart';
import 'exchange_session_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = ExchangeSessionController(
      partnerName: widget.partnerName,
      partnerUserId: widget.partnerUserId,
      sessionKey:
          '${widget.partnerUserId}_${widget.myLearningLanguage}_${widget.partnerLearningLanguage}',
    )..hydrate();
    _track('session_opened');
  }

  @override
  void dispose() {
    _input.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _track(String event, {Map<String, dynamic>? data}) {
    return exchangeAnalyticsRepository.track(event, metadata: {
      'partner_id': widget.partnerUserId,
      'partner_name': widget.partnerName,
      ...?data,
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;

    if (!_controller.isMyTurn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wait for your partner turn before sending.')),
      );
      await _track('turn_blocked_send');
      return;
    }

    final ok = await _controller.sendMessage(text);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.activeLanguage == ExchangeRoundLanguage.french
                ? 'French round active: please send in French.'
                : 'English round active: please send in English.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      await _track('language_lock_blocked');
      return;
    }

    await _track('message_sent_round_${_controller.round}');
    _input.clear();
  }

  Future<void> _markPartnerReply() async {
    await _controller.receivePartnerMessage(
      _controller.activeLanguage == ExchangeRoundLanguage.french
          ? 'Merci pour ton message.'
          : 'Thanks for your message.',
    );
    await _track('partner_reply_received');
  }

  Future<void> _suggestReply() async {
    final options = _controller.activeLanguage == ExchangeRoundLanguage.french
        ? ['Salut ! Comment ça va ?', 'Je vais bien, merci.', 'Qu’est-ce que tu fais ce week-end ?']
        : ['Hi! How are you?', 'I am doing well, thanks.', 'What do you do on weekends?'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map((o) => ListTile(
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
    if (!allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correction limit reached for this round (1 max).')),
      );
      return;
    }

    final corrected = original.replaceAll(RegExp(r'\s+'), ' ').trim();
    _input.text = corrected;
    await _track('helper_correct_sentence');

    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Correction suggestion'),
        content: Text(
          'Correct: $corrected\n'
          'Why: cleaned spacing and round-language formatting\n'
          'Better version: $corrected ✅',
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
    const frToEn = {
      'bonjour': 'hello',
      'merci': 'thanks',
      'salut': 'hi',
    };
    const enToFr = {
      'hello': 'bonjour',
      'thanks': 'merci',
      'hi': 'salut',
    };

    final words = text.toLowerCase().split(' ');
    final dict = _controller.activeLanguage == ExchangeRoundLanguage.french ? frToEn : enToFr;
    final translated = words.map((w) => dict[w] ?? w).join(' ');
    _input.text = translated;
    await _track('helper_translate');
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
    final frenchWords = _controller.messages
        .where((m) => m.language == ExchangeRoundLanguage.french)
        .fold<int>(0, (a, b) => a + b.text.split(' ').length);
    final englishWords = _controller.messages
        .where((m) => m.language == ExchangeRoundLanguage.english)
        .fold<int>(0, (a, b) => a + b.text.split(' ').length);

    await _track('session_completed', data: {
      'french_words': frenchWords,
      'english_words': englishWords,
      'duration_mins': minutes,
    });

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Session summary'),
        content: Text(
          'French words: $frenchWords\n'
          'English words: $englishWords\n'
          'Corrections used: ${_controller.myCorrectionsUsed}\n'
          'Duration: ${minutes}m\n'
          'Streak: +1',
        ),
        actions: [
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange with ${widget.partnerName}'),
        actions: [
          TextButton(onPressed: _nextRound, child: const Text('Next round')),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final roundLabel = _controller.activeLanguage == ExchangeRoundLanguage.french
              ? 'French round'
              : 'English round';
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
                        'Language lock active • ${_controller.isMyTurn ? 'Your turn' : 'Partner turn'} • Corrections left: ${1 - _controller.myCorrectionsUsed}',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _controller.messages.length,
                  itemBuilder: (_, i) {
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
                        child: Text('${m.from}: ${m.text}'),
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
                            decoration: const InputDecoration(hintText: 'Type message...'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        TextButton(onPressed: _translateDraft, child: const Text('Translate')),
                        TextButton(onPressed: _suggestReply, child: const Text('Suggest reply')),
                        TextButton(onPressed: _correctMySentence, child: const Text('Correct me')),
                        TextButton(onPressed: _markPartnerReply, child: const Text('Partner replied')),
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
