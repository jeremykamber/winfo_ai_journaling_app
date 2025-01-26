import 'package:stacked/stacked.dart';

class AiPromptBarModel extends BaseViewModel {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  Future<void> sendPrompt(String prompt, Function(String) onSend) async {
    if (prompt.trim().isEmpty) return;
    
    setBusy(true);
    await onSend(prompt);
    setBusy(false);
  }
}
