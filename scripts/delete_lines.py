import os

file_path = "lib/features/social/dm_chat_screen.dart"
with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

# 1-indexed start and end lines to remove
ranges_to_remove = [
    (335, 359), # _applyAutoCorrectBeforeSend
    (361, 380), # _openTutorPersonaPicker
    (382, 401), # _openAutoCorrectPicker
    (470, 472), # _mockTranslateText
    (474, 477), # _isLikelyEnglish
    (479, 485), # _buildTransliteration
    (487, 496), # _composerSuggestionsForLevel
    (498, 595), # _runCorrectionMode
    (597, 616), # _buildCorrection
    (618, 674), # _showWordExplanation
    (676, 708), # _sendWithUndoWindow
    (710, 727), # _scheduleMessage
    (729, 737), # _muteConversationOneHour
    (739, 743), # _isMessageMutedByKeyword
    (745, 763), # _addMutedKeyword
    (840, 849), # _loadDisappearingWindow
    (851, 859), # _loadThemeStyle
    (862, 876), # _loadPremiumToggles
    (879, 906), # _loadLearningPracticeState
    (908, 915), # _saveLearningPreferences
    (930, 934), # _toggleScreenshotWarning
    (943, 983), # _showPrivacyControls
    (985, 1014), # _rewriteDraftStyle
    (1017, 1039), # _openConversationReplayMode
    (1041, 1061), # _showWeeklyLearningReportCard
    (1063, 1093), # _showVoicePronunciationCoach
    (1131, 1152), # _showMessagePackPicker
    (1197, 1234), # _chooseDisappearingWindow
    (1236, 1257), # _chooseThemeStyle
    (1259, 1264), # _themeLabel
    (1266, 1276), # _chatBackgroundGradient
    (1278, 1303), # _aiPolishDraft
    (4477, 4482), # _CorrectionResult
    (4484, 4511), # _WordInsight
]

# Create a set of line numbers to remove (1-indexed)
lines_to_remove = set()
for start, end in ranges_to_remove:
    for i in range(start, end + 1):
        lines_to_remove.add(i)

new_lines = []
for i, line in enumerate(lines, 1):
    if i not in lines_to_remove:
        new_lines.append(line)

with open(file_path, "w", encoding="utf-8") as f:
    f.writelines(new_lines)

print(f"Removed {len(lines_to_remove)} lines from {file_path}")
