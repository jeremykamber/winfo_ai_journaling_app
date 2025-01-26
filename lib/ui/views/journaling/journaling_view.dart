import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:winfo_ai_journaling_app/ui/widgets/common/ai_prompt_bar/ai_prompt_bar.dart';
import 'package:winfo_ai_journaling_app/ui/widgets/common/langchain_testing/langchain_testing.dart';
import 'package:winfo_ai_journaling_app/ui/widgets/common/message_bubble/message_bubble.dart';

import 'journaling_viewmodel.dart';

class JournalingView extends StackedView<JournalingViewModel> {
  const JournalingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    JournalingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4E8),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (viewModel.showChatPanel) ...[
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: viewModel.journalController,
                          minLines: 10, // Increased minLines
                          maxLines: 100, // Increased maxLines
                          decoration: const InputDecoration(
                            hintText: 'Write your journal entry...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 30,
                      child: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          viewModel.clearJournalField();
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final msg = viewModel.messages[index];
                      return MessageBubble(
                        message: msg['text'],
                        isFromUser: !msg['isAi'],
                        isAi: msg['isAi'],
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  child: AiPromptBar(
                      onSend: (String text) =>
                          viewModel.askAI(viewModel.promptController.text)),
                ),
              ] else ...[
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final msg = viewModel.messages[index];
                      return MessageBubble(
                        message: msg['text'],
                        isFromUser: !msg['isAi'],
                        isAi: msg['isAi'],
                      );
                    },
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: viewModel.journalController,
                          minLines: 10, // Increased minLines
                          maxLines: 100, // Increased maxLines
                          decoration: const InputDecoration(
                            hintText: 'Write your journal entry...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[300],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            viewModel.saveJournalEntry();
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 30,
                      child: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          viewModel.clearJournalField();
                        },
                      ),
                    ),
                  ],
                ),
              ],
              if (viewModel.loadingState.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(viewModel.loadingState),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  JournalingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      JournalingViewModel();
}
