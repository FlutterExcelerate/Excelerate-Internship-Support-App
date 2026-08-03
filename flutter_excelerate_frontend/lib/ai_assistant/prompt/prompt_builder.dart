import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_context.dart';
import '../context/ai_context_provider.dart';

class PromptBuilder {
  const PromptBuilder._();

  static String buildSystemPrompt({
    AiApplicationContext? appContext,
    String? basePrompt,
  }) {
    final buffer = StringBuffer();
    if (basePrompt != null) {
      buffer.writeln(basePrompt);
      buffer.writeln();
    }

    if (appContext != null) {
      final user = appContext.userContext;
      if (user != null) {
        buffer.writeln('The user is a ${user.role} in the organization.');

        if (user.role.toLowerCase() == 'admin') {
          buffer.writeln(
            '\nYou are the Admin AI Assistant. You have full visibility into the system.',
          );
          buffer.writeln(
            'You can answer questions like: "How many programs exist?", "Which program expires first?", "Which modules are unpublished?", "Which students are inactive?", "How many users joined?", "Any pending notifications?", "How many seats remain?", "Show all beginner programs.", "Show React course details.", "Explain Security settings.", "Summarize Dashboard."',
          );
          buffer.writeln(
            'You should also provide intelligent suggestions to the admin, such as: "You have 2 unpublished programs.", "There are no admin emails configured.", "2 programs will expire soon.", or "No users have logged in today." if the context reflects these states.',
          );

          buffer.writeln('\n### ACTION EXECUTION ###');
          buffer.writeln(
            'You have the ability to execute actions in the admin interface.',
          );
          buffer.writeln(
            'To execute an action, append a JSON block at the very end of your response in this exact format:',
          );
          buffer.writeln(
            '[ACTION: {"type": "actionType", "payload": {"key": "value"}}]',
          );
          buffer.writeln('\nSupported Admin Action Types:');
          buffer.writeln('- "openContent": Navigate to Content tab.');
          buffer.writeln('- "openUsers": Navigate to Users tab.');
          buffer.writeln('- "openSecurity": Navigate to Security tab.');
          buffer.writeln(
            '- "openDashboard": Navigate to Dashboard Overview tab.',
          );
          buffer.writeln('- "createProgram": Open the Create Program dialog.');
          buffer.writeln('- "openNotifications": Open Notifications dialog.');
          buffer.writeln(
            '- "openProgram": Open a specific program (payload: {"programTitle": "..."}).',
          );
          buffer.writeln(
            '- "searchProgram", "searchUser", "searchModule": Execute search (payload: {"query": "..."}).',
          );
          buffer.writeln(
            '- "publishProgram": Publish a program (payload: {"programTitle": "..."}).',
          );
          buffer.writeln(
            '- "reviewUsers": Navigate to Users tab to review users.',
          );
          buffer.writeln(
            'If you execute an action, also provide a helpful text response explaining what you did.',
          );
        }
      }

      final screen = appContext.currentScreenContext;
      if (screen != null) {
        buffer.writeln(
          'The user is currently viewing the ${screen.screenName} screen.',
        );
      }
    }

    return buffer.toString();
  }

  static String buildUserPrompt({
    required String userInput,
    AiApplicationContext? appContext,
    AiContext? additionalContext,
  }) {
    final buffer = StringBuffer();

    if (additionalContext != null && additionalContext.documents.isNotEmpty) {
      buffer.writeln('\n### Reference Documents ###');
      for (var i = 0; i < additionalContext.documents.length; i++) {
        buffer.writeln(
          'Document ${i + 1}:\n${additionalContext.documents[i]}\n',
        );
      }
      buffer.writeln('----------------------------------------');
    }

    if (buffer.isNotEmpty) {
      buffer.writeln('\nQuestion: $userInput');
    } else {
      buffer.write(userInput);
    }

    return buffer.toString();
  }
}
