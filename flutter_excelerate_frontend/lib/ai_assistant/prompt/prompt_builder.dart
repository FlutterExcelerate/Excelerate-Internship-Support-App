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

    if (appContext == null) return buffer.toString();

    final user = appContext.userContext;
    final isAdmin = user?.role.toLowerCase() == 'admin';

    if (user != null) {
      buffer.writeln('### Current User ###');
      buffer.writeln('- Name: ${user.name}');
      buffer.writeln('- Role: ${user.role}');
      final prefs = user.preferences;
      if (prefs != null) {
        if (prefs['cohort']?.toString().isNotEmpty == true) {
          buffer.writeln('- Cohort: ${prefs['cohort']}');
        }
        if (prefs['location']?.toString().isNotEmpty == true) {
          buffer.writeln('- Location: ${prefs['location']}');
        }
        if (prefs['headline']?.toString().isNotEmpty == true) {
          buffer.writeln('- Headline: ${prefs['headline']}');
        }
        final skills = prefs['skills'];
        if (skills is List && skills.isNotEmpty) {
          buffer.writeln('- Skills: ${(skills).join(', ')}');
        }
      }
      buffer.writeln();
    }

    final programs = appContext.programsContext?.programs;
    if (programs != null && programs.isNotEmpty) {
      buffer.writeln('### Available Programs / Courses ###');
      for (final p in programs) {
        buffer.writeln('- [${p.status ?? 'published'}] ${p.title} (${p.category})');
        if (p.description.isNotEmpty) {
          final desc = p.description.length > 180
              ? '${p.description.substring(0, 180)}…'
              : p.description;
          buffer.writeln('  $desc');
        }
      }
      buffer.writeln();
    }

    if (isAdmin) {
      buffer.writeln(
        'You are the Admin AI Assistant. You have full visibility into the system.',
      );
      buffer.writeln(
        'You can answer questions like: "How many programs exist?", "Which program expires first?", "Which modules are unpublished?", "Which students are inactive?", "How many users joined?", "Any pending notifications?", "How many seats remain?", "Show all beginner programs.", "Show React course details.", "Explain Security settings.", "Summarize Dashboard."',
      );
      buffer.writeln(
        'You should also provide intelligent suggestions to the admin, such as: "You have 2 unpublished programs.", "There are no admin emails configured.", "2 programs will expire soon.", or "No users have logged in today." if the context reflects these states.',
      );

      final adminUsers = appContext.adminUsersContext;
      final studentProfiles = adminUsers?.studentProfiles;
      if (studentProfiles != null && studentProfiles.isNotEmpty) {
        buffer.writeln('### Student Roster (${studentProfiles.length} students) ###');
        for (final s in studentProfiles) {
          final name = (s['name'] as String?)?.isNotEmpty == true
              ? s['name']
              : 'Unknown';
          final active = s['isActive'] == true ? 'active' : 'inactive';
          final cohort = (s['cohort'] as String?)?.isNotEmpty == true
              ? ', cohort: ${s['cohort']}'
              : '';
          final location = (s['location'] as String?)?.isNotEmpty == true
              ? ', location: ${s['location']}'
              : '';
          final skills = s['skills'];
          final skillStr = (skills is List && skills.isNotEmpty)
              ? ', skills: ${skills.join(', ')}'
              : '';
          buffer.writeln('- $name ($active$cohort$location$skillStr)');
        }
        buffer.writeln();
      }

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

    final screen = appContext.currentScreenContext;
    if (screen != null && screen.screenName.isNotEmpty) {
      buffer.writeln(
        'The user is currently viewing the ${screen.screenName} screen.',
      );
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

