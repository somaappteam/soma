import 'dart:io';

void main() {
  final file = File('lib/features/social/dm_chat_screen.dart');
  var content = file.readAsStringSync();

  final methodsToRemove = [
    '_applyAutoCorrectBeforeSend',
    '_openTutorPersonaPicker',
    '_openAutoCorrectPicker',
    '_aiPolishDraft',
    '_rewriteDraftStyle',
    '_openConversationReplayMode',
    '_showWeeklyLearningReportCard',
    '_isLikelyEnglish',
    '_buildTransliteration',
    '_composerSuggestionsForLevel',
    '_runCorrectionMode',
    '_buildCorrection',
    '_showWordExplanation',
    '_sendWithUndoWindow',
    '_scheduleMessage',
    '_muteConversationOneHour',
    '_isMessageMutedByKeyword',
    '_addMutedKeyword',
    '_showVoicePronunciationCoach',
    '_showMessagePackPicker',
    '_openMoreDmToolsSheet',
    '_chooseDisappearingWindow',
    '_chooseThemeStyle',
    '_themeLabel',
    '_chatBackgroundGradient',
    '_showPrivacyControls',
  ];

  for (final method in methodsToRemove) {
    // Basic approach: find the method signature, then count braces
    // This regex looks for `[ReturnType] _methodName(` or `_methodName(` or `get _methodName`
    // We strictly look for the method name followed by '(' or '=>'
    final regex = RegExp(r'(Future<.*?>|String|bool|List<.*?>|void|_CorrectionResult)?\s*' + method + r'\s*\([^)]*\)\s*(async\s*)?\{');
    final match = regex.firstMatch(content);
    if (match != null) {
      final int start = match.start;
      int braceCount = 0;
      int idx = start;
      bool inString = false;
      String stringChar = '';
      bool foundFirstBrace = false;

      while (idx < content.length) {
        final char = content[idx];
        if (!inString && (char == '"' || char == "'")) {
          inString = true;
          stringChar = char;
        } else if (inString && char == stringChar && content[idx - 1] != r'\') {
          inString = false;
        } else if (!inString) {
          if (char == '{') {
            braceCount++;
            foundFirstBrace = true;
          } else if (char == '}') {
            braceCount--;
          }
        }

        idx++;
        if (foundFirstBrace && braceCount == 0) {
          break;
        }
      }

      final int end = idx;
      print('Removing $method (${end - start} chars)');
      content = content.replaceRange(start, end, '');
    } else {
      // maybe it's an arrow function like _themeLabel
      final arrowRegex = RegExp(r'(Future<.*?>|String|bool|List<.*?>|void)?\s*' + method + r'\s*\([^)]*\)\s*=>.*?;', dotAll: true);
      final arrowMatch = arrowRegex.firstMatch(content);
      if (arrowMatch != null) {
        print('Removing arrow method $method');
        content = content.replaceRange(arrowMatch.start, arrowMatch.end, '');
      } else {
        print('Could not find $method');
      }
    }
  }

  // Also strip out 'translatedText' block inside _sendText
  final translatedTextRegex = RegExp(r'String\? translatedText;.*?// Fallback or ignore\s*}\s*}', dotAll: true);
  if (translatedTextRegex.hasMatch(content)) {
    content = content.replaceAll(translatedTextRegex, '');
    print('Removed translatedText block.');
  }

  file.writeAsStringSync(content);
}
