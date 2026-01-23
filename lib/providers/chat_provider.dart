import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

/// Chat state
class ChatState {
  final bool isLoading;
  final List<ChatMessage> messages;
  final String? error;

  ChatState({
    this.isLoading = false,
    this.messages = const [],
    this.error,
  });

  ChatState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
    String? error,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      error: error,
    );
  }
}

/// Chat provider notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  String? _reportContext;
  String _language = 'en';

  ChatNotifier(this._chatService) : super(ChatState());

  /// Initialize with report context
  void initWithReport(String reportContext, String language) {
    _reportContext = reportContext;
    _language = language;
    state = ChatState(); // Reset messages
  }

  /// Send a message
  Future<void> sendMessage(String message) async {
    if (_reportContext == null) return;
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(message);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // Build conversation history for context
      final history = state.messages
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      // Get AI response
      final response = await _chatService.sendMessage(
        message: message,
        reportContext: _reportContext!,
        language: _language,
        conversationHistory: history.sublist(0, history.length - 1), // Exclude current message
      );

      // Add assistant message
      final assistantMessage = ChatMessage.assistant(response);
      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear chat
  void clear() {
    state = ChatState();
    _reportContext = null;
  }
}

/// Chat service provider
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

/// Chat provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) {
    final service = ref.watch(chatServiceProvider);
    return ChatNotifier(service);
  },
);
