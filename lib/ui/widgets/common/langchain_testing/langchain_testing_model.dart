import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';

class LangchainTestingModel extends BaseViewModel {
  TextEditingController inputController = TextEditingController();
  ChatOllama llm = ChatOllama();
  String llmResponse = '';

  void invokeLLM(String input) async {
    llmResponse = '';
    PromptValue prompt = PromptValue.string(input);
    setBusy(true);
    final stream =
        llm.stream(PromptValue.string(input));
    final chunks = <ChatResult>[];
    await for (final chunk in stream) {
      chunks.add(chunk);
      llmResponse += chunk.outputAsString;
      rebuildUi();
    }
    setBusy(false);
    rebuildUi();
  }
}
