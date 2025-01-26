import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:winfo_ai_journaling_app/services/ai_journaling_assistant_service.dart';

class JournalingViewModel extends BaseViewModel {
  final TextEditingController journalController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  String aiResponse = '';
  List<String> journalEntries = [];
  List<Map<String, dynamic>> messages = []; // Holds text & 'isAi'
  late final AiJournalingAssistantService _assistantService;
  bool _isInitialized = false;
  bool showChatPanel = false;
  String get loadingState => _assistantService.loadingState;

  JournalingViewModel() {
    _assistantService = AiJournalingAssistantService();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _assistantService.initialize();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> saveJournalEntry() async {
    if (journalController.text.isNotEmpty) {
      final entry =
          '[DATE: ${DateTime.now().toIso8601String()}]\n${journalController.text}';
      journalEntries.add(entry);
      _assistantService.addEntryToRAG(entry); // Appends entry to the RAG file
      showChatPanel = true;
      notifyListeners();
    }
  }

  void clearJournalField() {
    showChatPanel = false;
    journalController.clear();
    notifyListeners();
  }

  Future<void> askAI(String prompt) async {
    debugPrint('Prompt: $prompt');
    messages.add({'text': prompt, 'isAi': false}); // User message
    if (!_isInitialized) await initialize();

    setBusy(true);
    notifyListeners();

    final existingChatData = journalEntries.join('\n\n');
    final stream = _assistantService.invokeLLM(
      input: prompt,
      existingChatData: existingChatData,
    );

    aiResponse = '';
    await for (final chunk in stream) {
      if (messages.last['isAi'] == false) {
        messages.add({'text': '', 'isAi': true});
      } else {
        messages.last['text'] += chunk.toString();
      } // AI message
      aiResponse += chunk.toString();
      notifyListeners();
    }

    setBusy(false);
    promptController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    journalController.dispose();
    promptController.dispose();
    super.dispose();
  }
}
