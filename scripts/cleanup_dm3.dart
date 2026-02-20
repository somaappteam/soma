import 'dart:io';

void main() {
  final file = File('lib/features/social/dm_chat_screen.dart');
  var content = file.readAsStringSync();

  final regex1 = RegExp(r'Future<void>\s+_loadDisappearingWindow\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex1, '');

  final regex2 = RegExp(r'Future<void>\s+_loadThemeStyle\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex2, '');

  final regex3 = RegExp(r'Future<void>\s+_loadPremiumToggles\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex3, '');

  final regex4 = RegExp(r'Future<void>\s+_loadLearningPracticeState\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex4, '');

  final regex5 = RegExp(r'Future<void>\s+_saveLearningPreferences\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex5, '');

  final regex6 = RegExp(r'Future<void>\s+_toggleDmLock\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex6, '');
  
  final regex7 = RegExp(r'Future<void>\s+_toggleScreenshotWarning\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex7, '');
  
  final regex8 = RegExp(r'Future<void>\s+_toggleHidePreview\(\)\s*async\s*\{.*?\}\s*;?', dotAll: true);
  content = content.replaceAll(regex8, '');

  file.writeAsStringSync(content);
}
