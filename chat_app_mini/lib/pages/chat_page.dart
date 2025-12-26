import 'package:chat_app_mini/components/chat_bubble.dart';
import 'package:chat_app_mini/components/my_text_field.dart';
import 'package:chat_app_mini/services/auth_service.dart';
import 'package:chat_app_mini/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/confirmation_dialog.dart';
import '../utils/show_snackbar.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSending = false;

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text.trim(),
      );

      _messageController.clear();
      _scrollToBottom();

    } catch (e) {
      showAppSnackBar(context, "Send message failed!", Colors.redAccent);
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Scroll chỉ khi list dài hơn viewport
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 15.h),
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs
            .map((doc) => _buildMessageItem(doc))
            .toList();

        // Scroll xuống cuối cùng sau khi list đã build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) => messages[index],
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderId'] == _authService.getCurrentUser()!.uid;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 20.w),
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
        onLongPress: () async {
          final confirm = await showConfirmationDialog(
            context,
            title: "Delete message",
            message: "Are you sure you want to delete this message?",
            confirmText: "Delete",
            cancelText: "Cancel",
          );

          if (confirm == true) {
            await _chatService.deleteMessage(
              userId: _authService.getCurrentUser()!.uid,
              otherUserId: widget.receiverId,
              messageId: doc.id,
            );
          }
        },
      ),
    );
  }

  Widget _buildUserInput() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: 10.h,
        left: 10.w,
        right: 10.w,
        top: 10.h,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isSending ? null : sendMessage,
              icon: _isSending
                  ? SizedBox(
                width: 18.sp,
                height: 18.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
