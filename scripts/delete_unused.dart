import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

void main() {
  final path = 'lib/features/social/dm_chat_screen.dart';
  final file = File(path);
  final content = file.readAsStringSync();

  final result = parseString(content: content, throwIfDiagnostics: false);

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

  final nodesToRemove = <AstNode>[];

  result.unit.visitChildren(_Visitor((node) {
    if (node is MethodDeclaration) {
      if (methodsToRemove.contains(node.name.lexeme)) {
        nodesToRemove.add(node);
      }
    }
  }));

  // Sort nodes in reverse order so we can delete from end to start without affecting offsets
  nodesToRemove.sort((a, b) => b.offset.compareTo(a.offset));

  var newContent = content;
  for (final node in nodesToRemove) {
    print('Removing ${node.runtimeType} at ${node.offset} - ${node.end}');
    newContent = newContent.replaceRange(node.offset, node.end, '');
  }

  file.writeAsStringSync(newContent);
  print('Done.');
}

class _Visitor extends RecursiveAstVisitor<void> {
  final void Function(AstNode) onNode;
  _Visitor(this.onNode);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    onNode(node);
    super.visitMethodDeclaration(node);
  }
}
