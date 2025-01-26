import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'ai_prompt_bar_model.dart';

class AiPromptBar extends StackedView<AiPromptBarModel> {
  final Function(String) onSend;
  final String hintText;
  final bool showExpandButton;

  const AiPromptBar({
    super.key,
    required this.onSend,
    this.hintText = 'Ask me anything...',
    this.showExpandButton = true,
  });

  @override
  Widget builder(
    BuildContext context,
    AiPromptBarModel viewModel,
    Widget? child,
  ) {
    final controller = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 1,
              minLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.brown[300], // Changed to light brown
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: viewModel.isBusy
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
              onPressed: viewModel.isBusy
                  ? null
                  : () {
                      viewModel.sendPrompt(
                        controller.text,
                        onSend,
                      );
                      controller.clear();
                    },
            ),
          ),
        ],
      ),
    );
  }

  @override
  AiPromptBarModel viewModelBuilder(BuildContext context) => AiPromptBarModel();
}
