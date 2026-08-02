import 'package:flutter/material.dart';
import '../models/ai_message.dart';
import 'ai_message_bubble.dart';

class AiConversationView extends StatefulWidget {
  final List<AiMessage> messages;

  const AiConversationView({
    super.key,
    required this.messages,
  });

  @override
  State<AiConversationView> createState() => _AiConversationViewState();
}

class _AiConversationViewState extends State<AiConversationView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(AiConversationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length || 
        (widget.messages.isNotEmpty && oldWidget.messages.isNotEmpty && widget.messages.last.content.length > oldWidget.messages.last.content.length)) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final message = widget.messages[index];
          final isConsecutive = index > 0 && widget.messages[index - 1].role == message.role;
          
          return AiMessageBubble(
            message: message,
            isConsecutive: isConsecutive,
          );
        },
      ),
    );
  }
}


