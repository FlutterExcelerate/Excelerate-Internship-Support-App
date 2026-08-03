import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/context/ai_admin_context.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/context/ai_context_provider.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/context/context_manager.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/controller/ai_chat_controller.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/ai_config.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/conversation_engine.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/core/persona/ai_persona.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/module/ai_action.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/services/ai_repository.dart';
import 'package:flutter_excelerate_frontend/ai_assistant/widget/ai_chat_page.dart';

import '../core/ai_logger.dart';

class AiModule {
  static AiModule? _instance;

  late final AiChatController _studentController;
  late final AiChatController _adminController;
  late final ContextManager _contextManager;

  final _actionController = StreamController<AiActionRequest>.broadcast();
  Stream<AiActionRequest> get actionStream => _actionController.stream;

  void emitAction(AiActionRequest request) {
    if (!_actionController.isClosed) {
      _actionController.add(request);
    }
  }

  AiModule._internal({
    required ContextManager contextManager,
    required AiChatController studentController,
    required AiChatController adminController,
  }) : _contextManager = contextManager,
       _studentController = studentController,
       _adminController = adminController {
    _setupLifecycle();
  }

  late final AppLifecycleListener _lifecycleListener;

  void _setupLifecycle() {
    AiLogger.log('Initializing module lifecycle', tag: 'Lifecycle');
    _lifecycleListener = AppLifecycleListener(
      onPause: () {
        AiLogger.log('App paused, cancelling requests', tag: 'Lifecycle');
        _studentController.cancelPendingRequests();
        _adminController.cancelPendingRequests();
      },
    );
  }

  static bool get isInitialized => _instance != null;

  static AiModule get instance {
    if (_instance == null) {
      throw StateError(
        'AiModule has not been initialized. Call AiModule.initialize() first.',
      );
    }
    return _instance!;
  }

  static void initialize({String? baseSystemPrompt, String? apiKey}) {
    if (_instance != null) return;

    final config = AiConfig.fromEnvironment(apiKey: apiKey);

    final contextManager = ContextManager(
      baseSystemPrompt:
          baseSystemPrompt ??
          'You are an intelligent, helpful assistant for the educational platform. Provide concise, encouraging, and accurate answers.',
    );

    final studentEngine = ConversationEngine(
      initialConversationId: 'student_conversation',
    );
    final adminEngine = ConversationEngine(
      initialConversationId: 'admin_conversation',
    );

    final studentRepository = AiRepositoryImpl(
      config: config,
      contextManager: contextManager,
      conversationEngine: studentEngine,
    );

    final adminRepository = AiRepositoryImpl(
      config: config,
      contextManager: contextManager,
      conversationEngine: adminEngine,
    );

    final studentController = AiChatController(
      repository: studentRepository,
      conversationId: 'student_conversation',
    )..loadHistory();

    final adminController = AiChatController(
      repository: adminRepository,
      conversationId: 'admin_conversation',
    )..loadHistory();

    _instance = AiModule._internal(
      contextManager: contextManager,
      studentController: studentController,
      adminController: adminController,
    );
  }

  void updateApplicationContext(AiApplicationContext context) {
    AiLogger.log('Hard replacing application context', tag: 'Context');
    _contextManager.updateContext(context);
  }

  AiApplicationContext get currentContext => _contextManager.currentContext;

  void patchApplicationContext({
    AiUserContext? user,
    AiProfileContext? profile,
    AiScreenContext? screen,
    AiSystemContext? system,
    AiProgramsContext? programs,
    AiAssignmentsContext? assignments,
    AiDailyPulseContext? pulse,
    AiDashboardContext? dashboard,
    AiAdminDashboardContext? adminDashboardContext,
    AiAdminContentContext? adminContentContext,
    AiAdminUsersContext? adminUsersContext,
    AiAdminSecurityContext? adminSecurityContext,
  }) {
    AiLogger.log(
      'Patching context',
      tag: 'Context',
      data: {'screen': screen?.screenName, 'userId': user?.id},
    );
    final current = _contextManager.currentContext;

    bool changed = false;
    if (user != null && user.id != current.userContext?.id) changed = true;
    if (profile != null) changed = true;
    if (screen != null &&
        screen.screenName != current.currentScreenContext?.screenName) {
      changed = true;
    }
    if (system != null) changed = true;
    if (programs != null && programs != current.programsContext) changed = true;
    if (assignments != null && assignments != current.assignmentsContext) {
      changed = true;
    }
    if (pulse != null &&
        pulse.lastMood != current.dailyPulseContext?.lastMood) {
      changed = true;
    }
    if (dashboard != null) changed = true;
    if (adminDashboardContext != null) changed = true;
    if (adminContentContext != null) changed = true;
    if (adminUsersContext != null) changed = true;
    if (adminSecurityContext != null) changed = true;

    if (!changed) return;

    _contextManager.updateContext(
      current.copyWith(
        userContext: user,
        profileContext: profile,
        currentScreenContext: screen,
        systemContext: system,
        programsContext: programs,
        assignmentsContext: assignments,
        dailyPulseContext: pulse,
        dashboardContext: dashboard,
        adminDashboardContext: adminDashboardContext,
        adminContentContext: adminContentContext,
        adminUsersContext: adminUsersContext,
        adminSecurityContext: adminSecurityContext,
      ),
    );
  }

  void openChat(BuildContext context, {required AiPersona persona}) {
    final bool isAdmin = persona.runtimeType.toString() == 'AdminPersona';
    final controller = isAdmin ? _adminController : _studentController;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AiChatPage(controller: controller, persona: persona),
      ),
    );
  }

  static void dispose() {
    _instance?._lifecycleListener.dispose();
    _instance?._studentController.dispose();
    _instance?._adminController.dispose();
    _instance?._actionController.close();
    _instance = null;
  }
}
