import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:winfo_ai_journaling_app/ui/common/ui_helpers.dart';

import 'langchain_testing_model.dart';

class LangchainTesting extends StackedView<LangchainTestingModel> {
  const LangchainTesting({super.key});

  @override
  Widget builder(
    BuildContext context,
    LangchainTestingModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Text(viewModel.chatHistory),
              verticalSpaceMedium,
              TextField(
                controller: viewModel.inputController,
              ),
              verticalSpaceMedium,
              ElevatedButton(
                onPressed: () {
                  debugPrint(viewModel.inputController.text);
                  viewModel.invokeLLM(viewModel.inputController.text, viewModel.chatHistory);
                },
                child: Text('Invoke LLM'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LangchainTestingModel viewModelBuilder(
    BuildContext context,
  ) {
    final viewModel = LangchainTestingModel();
    viewModel.initialize();
    return viewModel;

  }
}
