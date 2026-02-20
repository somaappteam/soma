import "dart:io";

void main() {
  final file = File("lib/features/social/dm_chat_screen.dart");
  var content = file.readAsStringSync();

  // Fix initState
  content = content.replaceAll("    _loadDraft();\n", "");
  content = content.replaceAll("    if (widget.initialIncomingCall) {\n", "");

  // Remove unused fields at top
  content = content.replaceAll(RegExp(r"enum _DmThemeStyle \{[^}]+\}\n*"), "");
  content = content.replaceAll(RegExp(r"enum _TutorPersona \{[^}]+\}\n*"), "");
  content = content.replaceAll(RegExp(r"enum _AutoCorrectMode \{[^}]+\}\n*"), "");

  // Remove missing variables and methods usage in code
  content = content.replaceAll(RegExp(r"(\s*)_smoothedCallQualityScore(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_callQualityScore(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_callRecordingConsent(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_disappearingWindow(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_dmLocked(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_dmUnlocked(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_screenshotWarningEnabled(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_autoTranslateIncoming(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_autoTranslateLanguage(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_isMessageMutedByKeyword\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_muteUntil(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_duePracticePhrases(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_saveLearningPreferences\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_targetCefrLevel(.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_composerSuggestionsForLevel\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_runCorrectionMode\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_showWordExplanation\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_showVoicePronunciationCoach\((.*?);\n"), "");
  content = content.replaceAll(RegExp(r"(\s*)_chatBackgroundGradient\((.*?);?\n"), "");

  // Remove unused classes / methods entirely if they still exist
  content = content.replaceAll(RegExp(r"class _CorrectionResult \{[^}]+\}\n*"), "");
  content = content.replaceAll(RegExp(r"class _WordInsight \{[^}]+\}\n*"), "");
  content = content.replaceAll(RegExp(r"Widget _DmToolsSectionHeader\([^}]+\}\n*"), "");
  content = content.replaceAll(RegExp(r"class _WeeklyReportCard extends StatelessWidget \{[^}]+\}\n*"), "");

  file.writeAsStringSync(content);
  print("Cleanup 4 complete");
}

