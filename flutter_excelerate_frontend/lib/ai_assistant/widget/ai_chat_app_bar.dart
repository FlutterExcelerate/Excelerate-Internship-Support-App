import 'package:flutter/material.dart';

class AiChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClearChat;
  final String title;

  const AiChatAppBar({
    super.key,
    this.onClearChat,
    this.title = 'AI Assistant',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        if (onClearChat != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Chat',
            onPressed: onClearChat,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
