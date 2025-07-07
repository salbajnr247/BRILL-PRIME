
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/real_time_provider.dart';
import '../resources/constants/color_constants.dart';

class RealTimeChatWidget extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const RealTimeChatWidget({
    Key? key,
    required this.chatId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<RealTimeChatWidget> createState() => _RealTimeChatWidgetState();
}

class _RealTimeChatWidgetState extends State<RealTimeChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final realTimeProvider = Provider.of<RealTimeProvider>(context, listen: false);
      realTimeProvider.subscribeToChat(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        final messages = realTimeProvider.chatMessages[widget.chatId] ?? [];
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return Column(
          children: [
            // Chat header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Live Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: realTimeProvider.isConnected 
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: realTimeProvider.isConnected 
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          realTimeProvider.isConnected ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 10,
                            color: realTimeProvider.isConnected 
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages list
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: messages.isEmpty
                    ? const Center(
                        child: Text(
                          'No messages yet. Start the conversation!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildMessage(message);
                        },
                      ),
              ),
            ),
            
            // Message input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: realTimeProvider.isConnected 
                            ? 'Type your message...'
                            : 'Reconnecting...',
                        enabled: realTimeProvider.isConnected,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: realTimeProvider.isConnected 
                          ? (_) => _sendMessage(realTimeProvider)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: realTimeProvider.isConnected 
                        ? () => _sendMessage(realTimeProvider)
                        : null,
                    icon: Icon(
                      Icons.send,
                      color: realTimeProvider.isConnected 
                          ? ColorConstants.primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isCurrentUser = message['sender_id'] == widget.currentUserId;
    final messageText = message['message'] ?? '';
    final timestamp = message['timestamp'] != null 
        ? DateTime.parse(message['timestamp'])
        : DateTime.now();

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? ColorConstants.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageText,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                color: isCurrentUser 
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(RealTimeProvider realTimeProvider) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      realTimeProvider.sendChatMessage(
        widget.chatId,
        message,
        widget.currentUserId,
      );
      _messageController.clear();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
