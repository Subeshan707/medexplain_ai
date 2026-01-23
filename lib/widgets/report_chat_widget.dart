import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/chat_provider.dart';
import '../l10n/app_localizations.dart';

/// Chat widget for asking questions about the report
class ReportChatWidget extends ConsumerStatefulWidget {
  final String reportContext;
  final String language;
  
  const ReportChatWidget({
    super.key,
    required this.reportContext,
    required this.language,
  });

  @override
  ConsumerState<ReportChatWidget> createState() => _ReportChatWidgetState();
}

class _ReportChatWidgetState extends ConsumerState<ReportChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize chat with report context
    Future.microtask(() {
      ref.read(chatProvider.notifier).initWithReport(
        widget.reportContext,
        widget.language,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    ref.read(chatProvider.notifier).sendMessage(message);
    _messageController.clear();
    
    // Scroll to bottom after message is sent
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final l10n = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with expand/collapse
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, color: AppTheme.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ask Questions About Your Report',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: AppTheme.white,
                  ),
                ],
              ),
            ),
          ),
          
          // Chat content (expandable)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? 300 : 0,
            child: _isExpanded 
                ? Column(
                    children: [
                      // Messages list
                      Expanded(
                        child: chatState.messages.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Ask any questions about your medical report analysis.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(12),
                                itemCount: chatState.messages.length,
                                itemBuilder: (context, index) {
                                  final message = chatState.messages[index];
                                  return _buildMessageBubble(message);
                                },
                              ),
                      ),
                      
                      // Loading indicator
                      if (chatState.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Thinking...'),
                            ],
                          ),
                        ),
                      
                      // Input field
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.lightSurface,
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type your question...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: chatState.isLoading ? null : _sendMessage,
                              icon: const Icon(Icons.send),
                              color: AppTheme.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryBlue : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? AppTheme.white : AppTheme.neutralBlack,
          ),
        ),
      ),
    );
  }
}
