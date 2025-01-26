import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isFromUser;
  final bool isAi; // New field
  final EdgeInsets padding;

  const MessageBubble({
    super.key,
    required this.message,
    this.isFromUser = false,
    this.isAi = false, // New field
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isAi
                ? Colors.black54 // Dark tinted bubble for AI
                : (isFromUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isFromUser ? 16 : 4),
              bottomRight: Radius.circular(isFromUser ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            message,
            style: TextStyle(
              color: isFromUser ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
