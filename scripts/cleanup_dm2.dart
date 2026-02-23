import 'dart:io';

void main() {
  final file = File('lib/features/social/dm_chat_screen.dart');
  var content = file.readAsStringSync();

  // 1. Remove MessageBubble menu items
  final menu1 = '''
            if (msg.payload.type == 'text')
              ListTile(
                leading: const Icon(Icons.spellcheck_rounded),
                title: const Text('Correct this sentence'),
                onTap: () async {
                  Navigator.pop(context);
                  await _runCorrectionMode(msg);
                },
              ),
            if (msg.payload.type == 'text')
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Explain word'),
                onTap: () async {
                  Navigator.pop(context);
                  await _showWordExplanation(msg);
                },
              ),''';
              
  final menu2 = '''
            if (msg.payload.type == 'voice' && (msg.payload.transcript?.isNotEmpty ?? false))
              ListTile(
                leading: const Icon(Icons.record_voice_over_rounded),
                title: const Text('Pronunciation coach'),
                onTap: () async {
                  Navigator.pop(context);
                  await _showVoicePronunciationCoach(msg);
                },
              ),''';

  content = content.replaceAll(menu1, '');
  content = content.replaceAll(menu2, '');

  // 2. Remove unused sendText properties
  final payloadOptions = '''
      'tutor_persona': _tutorPersona.name,
      'autocorrect_mode': _autoCorrectMode.name,
      if (_examModeEnabled) 'exam_mode': true,
      if (!_isLikelyEnglish(text)) 'transliteration': _buildTransliteration(text),''';
  content = content.replaceAll(payloadOptions, '');

  final disappearingWindowOption = '''
      if (_disappearingWindow != null)
        'expires_at': DateTime.now().add(_disappearingWindow!).toIso8601String(),''';
  content = content.replaceAll(disappearingWindowOption, '');

  // 3. Remove variables
  final vars = [
    "String _draftText = '';",
    'int _callQualityScore = 78;',
    'int _smoothedCallQualityScore = 78;',
    'String? _pendingUndoText;',
    'DateTime? _muteUntil;',
    'final Set<String> _mutedKeywords = <String>{};',
    'Duration? _disappearingWindow;',
    '_DmThemeStyle _themeStyle = _DmThemeStyle.defaultStyle;',
    'bool _isConversationArchived = false;',
    'bool _autoTranslateIncoming = false;',
    "String _autoTranslateLanguage = 'English';",
    '_CefrLevel _targetCefrLevel = _CefrLevel.b1;',
    '_TutorPersona _tutorPersona = _TutorPersona.friendlyCoach;',
    '_AutoCorrectMode _autoCorrectMode = _AutoCorrectMode.off;',
    'bool _examModeEnabled = false;',
    'final List<String> _duePracticePhrases = <String>[];',
    'bool _dmLocked = false;',
    'bool _dmUnlocked = false;',
    'bool _screenshotWarningEnabled = true;',
    'bool _hidePreviewInInbox = false;',
    'bool _callRecordingConsent = false;'
  ];
  
  for (var v in vars) {
    content = content.replaceAll(RegExp(r'\s*' + RegExp.escape(v)), '');
  }

  // 4. Classes/enums to remove
  final toRemove = [
    '_CorrectionResult',
    '_WordInsight',
    '_DmToolsSectionHeader',
    '_WeeklyReportCard',
    '_themeLabel',
    '_autoCorrectLabel',
    '_tutorPersonaLabel',
    '_fmtCallDuration',
    '_chatBackgroundGradient'
  ];
  
  for (final method in toRemove) {
    final regex = RegExp(r'(class\s+|Future<.*?>|String|bool|List<.*?>|void|Widget)?\s*' + method + r'(\s+extends.*?)?\s*\([^)]*\)\s*(async\s*)?\{');
    final match = regex.firstMatch(content);
    if (match != null) {
      final int start = match.start;
      int braceCount = 0;
      int idx = start;
      bool foundFirstBrace = false;
      while (idx < content.length) {
        if (content[idx] == '{') {
          braceCount++;
          foundFirstBrace = true;
        } else if (content[idx] == '}') {
          braceCount--;
        }
        idx++;
        if (foundFirstBrace && braceCount == 0) break;
      }
      content = content.replaceRange(start, idx, '');
    }
  }

  // Also catch arrow functions again for the formatters
  final arrowRegex1 = RegExp(r'String\s+_tutorPersonaLabel\s*\([^)]+\)\s*=>.*?;', dotAll: true);
  content = content.replaceAll(arrowRegex1, '');
  final arrowRegex2 = RegExp(r'String\s+_autoCorrectLabel\s*\([^)]+\)\s*=>.*?;', dotAll: true);
  content = content.replaceAll(arrowRegex2, '');
  final arrowRegex3 = RegExp(r'String\s+_fmtCallDuration\s*\([^)]+\)\s*=>.*?;', dotAll: true);
  content = content.replaceAll(arrowRegex3, '');

  // 5. _composerSuggestionsForLevel is a switch Expression
  final compRegex = RegExp(r'List<String>\s+_composerSuggestionsForLevel\s*\([^)]+\)\s*\{.*?\}\s*;', dotAll: true);
  content = content.replaceAll(compRegex, '');

  file.writeAsStringSync(content);
  print('Cleanup pass 2 complete');
}
