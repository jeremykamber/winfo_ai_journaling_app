import 'package:flutter/material.dart';
import 'package:langchain_community/langchain_community.dart';
import 'package:stacked/stacked.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';

class LangchainTestingModel extends BaseViewModel {
  String ragFilePath =
      '/Users/jeremy/Development/Apps/winfo_ai_journaling_app/lib/ui/widgets/common/langchain_testing/journal_entries.txt';
  TextEditingController inputController = TextEditingController();
  ChatOllama llm = ChatOllama();
  String llmResponse = '';
  String chatHistory = '';

  // Add late initialization for retriever
  late VectorStoreRetriever _retriever;
  bool _isInitialized = false;

  // New initialization method
  Future<void> initialize() async {
    if (_isInitialized) return;
    _retriever = await get_rag_retriever();
    _isInitialized = true;
  }

  // Modify invokeLLM to use cached retriever
  void invokeLLM(String input, String existingChatData) async {
    if (!_isInitialized) {
      await initialize();
    }

    debugPrint('Invoking LLM with input: $input');
    chatHistory += '\n\n You: $input';
    rebuildUi();

    final promptTemplate = ChatPromptTemplate.fromTemplate('''
Answer the following question based on the given context:
{context}

... and the previous chat turns:

$existingChatData

Question: {question}''');

    final chain = Runnable.fromMap<String>({
          'context': _retriever | Runnable.mapInput((docs) => docs.join('\n')),
          'question': Runnable.passthrough(),
        }) |
        promptTemplate |
        llm |
        const StringOutputParser();

    setBusy(true);
    chatHistory += '\n\n Echo: ';
    final stream = chain.stream(input);
    final chunks = <Object>[];
    await for (final chunk in stream) {
      chunks.add(chunk);
      chatHistory += chunk.toString();
      debugPrint('Received chunk: $chunk');
      rebuildUi();
    }
    setBusy(false);
    debugPrint('LLM invocation completed');
    rebuildUi();
  }

  // Keep helper methods
  Future<VectorStoreRetriever> get_rag_retriever() async {
    debugPrint('Loading documents from $ragFilePath');
    final loader = TextLoader(ragFilePath);
    final documents = await loader.load();
    debugPrint('Documents loaded: ${documents.length}');

    const textSplitter = RecursiveCharacterTextSplitter(
      chunkSize: 800,
      chunkOverlap: 0,
    );
    final docs = textSplitter.splitDocuments(documents);
    debugPrint('Documents split into ${docs.length} chunks');

    final textsWithSources = docs
        .asMap()
        .entries
        .map(
          (entry) => entry.value.copyWith(
            metadata: {
              ...entry.value.metadata,
              'source': '${entry.key}-pl',
              'timestamp': extractDateFromContent(entry.value.pageContent)
                      ?.toIso8601String() ??
                  DateTime.now().toIso8601String(),
            },
          ),
        )
        .toList(growable: false);
    debugPrint('Texts with sources prepared');

    final embeddings = OllamaEmbeddings();
    debugPrint('Embedding documents');
    final result = await embeddings.embedDocuments(docs);
    debugPrint('Documents embedded');

    final docSearch = await MemoryVectorStore.fromDocuments(
      documents: textsWithSources,
      embeddings: embeddings,
    );
    debugPrint('MemoryVectorStore created');

    final retriever = docSearch.asRetriever();
    debugPrint('Retriever created');
    return retriever;
  }

  DateTime? extractDateFromContent(String content) {
    final dateRegex = RegExp(r'\[DATE: (.*?)\]');
    final match = dateRegex.firstMatch(content);
    if (match != null) {
      return DateTime.parse(match.group(1)!);
    }
    return null;
  }
}
