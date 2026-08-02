import 'package:flutter/material.dart';
import '../ai_module.dart';

import '../controllers/ai_chat_controller.dart';
import '../controllers/ai_chat_state.dart';
import '../widgets/ai_chat_app_bar.dart';
import '../widgets/ai_conversation_view.dart';
import '../widgets/ai_empty_state.dart';
import '../widgets/ai_error_widget.dart';
import '../widgets/ai_input_bar.dart';
import '../widgets/ai_typing_indicator.dart';
import '../core/personas/ai_persona.dart';

class AiChatPage extends StatefulWidget {
  final AiChatController controller;
  final AiPersona persona;

  const AiChatPage({
    super.key,
    required this.controller,
    required this.persona,
  });

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  String _lastInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AiChatAppBar(
        onClearChat: () => widget.controller.clearConversation(),
      ),
      body: ValueListenableBuilder<AiChatState>(
        valueListenable: widget.controller,
        builder: (context, state, child) {
          final isLoading = state.status == AiChatStatus.loading || state.status == AiChatStatus.streaming;

          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? AiEmptyState(
                        persona: widget.persona,
                        currentContext: AiModule.instance.currentContext,
                        onSuggestionTap: (text) {
                          _lastInput = text;
                          widget.controller.sendMessage(text, persona: widget.persona);
                        },
                      )
                    : AiConversationView(messages: state.messages),
              ),
              if (isLoading) const AiTypingIndicator(),
              if (state.error != null)
                AiErrorWidget(
                  error: state.error!,
                  onRetry: () => widget.controller.sendMessage(_lastInput, persona: widget.persona),
                ),
              AiInputBar(
                isEnabled: !isLoading,
                onSubmitted: (text) {
                  _lastInput = text;
                  widget.controller.sendMessage(text, persona: widget.persona);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}



