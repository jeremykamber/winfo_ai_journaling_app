import 'package:flutter/material.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_community/langchain_community.dart';
import 'dart:io';

class AiJournalingAssistantService extends ChangeNotifier {
  static const String _tag = 'AiJournalingAssistantService';
  String ragFilePath =
      '/Users/jeremy/Development/Apps/winfo_ai_journaling_app/lib/ui/widgets/common/langchain_testing/journal_entries.txt';
  late VectorStoreRetriever _retriever;
  bool _isInitialized = false;
  final ChatOllama llm = ChatOllama(defaultOptions: ChatOllamaOptions(model: 'granite3.1-moe'));
  String loadingState = '';

  AiJournalingAssistantService() {
    debugPrint('[$_tag] Service instantiated');
  }

  Future<void> initialize() async {
    debugPrint('[$_tag] Initializing service');
    loadingState = 'Loading model...';
    notifyListeners();
    try {
      _retriever = await _getRagRetriever();
      _isInitialized = true;
      debugPrint('[$_tag] Service successfully initialized');
      loadingState = '';
      notifyListeners();
    } catch (e) {
      debugPrint('[$_tag] Error initializing service: $e');
      loadingState = 'Error initializing model';
      notifyListeners();
      rethrow;
    }
  }

  Stream<Object> invokeLLM({
    required String input,
    required String existingChatData,
  }) async* {
    debugPrint('[$_tag] Invoking LLM with input: $input');
    loadingState = 'Thinking...';
    notifyListeners();
    await initialize();

    try {
      final promptTemplate = ChatPromptTemplate.fromTemplate('''
Answer the following question based on the given context:
{context}

... and the previous chat turns:

$existingChatData

Question: {question}''');
      debugPrint('[$_tag] Created prompt template');

      final chain = Runnable.fromMap<String>({
            'context': _retriever | Runnable.mapInput((docs) => docs.join('\n')),
            'question': Runnable.passthrough(),
          }) |
          promptTemplate |
          llm |
          const StringOutputParser();
      debugPrint('[$_tag] Chain created, starting stream');

      loadingState = 'Generating response...';
      notifyListeners();
      yield* chain.stream(input);
      loadingState = '';
      notifyListeners();
    } catch (e) {
      debugPrint('[$_tag] Error in invokeLLM: $e');
      loadingState = 'Error generating response';
      notifyListeners();
      rethrow;
    }
  }

  Future<VectorStoreRetriever> _getRagRetriever() async {
    debugPrint('[$_tag] Getting RAG retriever');
    try {
      final loader = TextLoader(ragFilePath);
      final documents = await loader.load();
      debugPrint('[$_tag] Loaded ${documents.length} documents');

      const textSplitter = RecursiveCharacterTextSplitter(
        chunkSize: 800,
        chunkOverlap: 0,
      );
      final docs = textSplitter.splitDocuments(documents);
      debugPrint('[$_tag] Split into ${docs.length} chunks');

      final textsWithSources = docs
          .asMap()
          .entries
          .map(
            (entry) => entry.value.copyWith(
              metadata: {
                ...entry.value.metadata,
                'source': '${entry.key}-pl',
                'timestamp': _extractDateFromContent(entry.value.pageContent)
                        ?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
              },
            ),
          )
          .toList(growable: false);
      debugPrint('[$_tag] Added metadata to chunks');

      final embeddings = OllamaEmbeddings();
      await embeddings.embedDocuments(docs);
      debugPrint('[$_tag] Created embeddings');

      final docSearch = await MemoryVectorStore.fromDocuments(
        documents: textsWithSources,
        embeddings: embeddings,
      );
      debugPrint('[$_tag] Created vector store');

      return docSearch.asRetriever();
    } catch (e) {
      debugPrint('[$_tag] Error in _getRagRetriever: $e');
      rethrow;
    }
  }

  DateTime? _extractDateFromContent(String content) {
    debugPrint('[$_tag] Extracting date from content');
    final dateRegex = RegExp(r'\[DATE: (.*?)\]');
    final match = dateRegex.firstMatch(content);
    if (match != null) {
      debugPrint('[$_tag] Date found: ${match.group(1)}');
      return DateTime.parse(match.group(1)!);
    }
    debugPrint('[$_tag] No date found in content');
    return null;
  }

  Future<void> addEntryToRAG(String text) async {
    debugPrint('[$_tag] Adding new entry to RAG');
    try {
      final file = File(ragFilePath);
      await file.writeAsString('\n\n$text', mode: FileMode.append);
      debugPrint('[$_tag] Successfully added entry to RAG');
    } catch (e) {
      debugPrint('[$_tag] Error adding entry to RAG: $e');
      rethrow;
    }
  }
}
