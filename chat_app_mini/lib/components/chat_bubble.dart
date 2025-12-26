import 'package:chat_app_mini/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.onLongPress,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onLongPress: widget.isCurrentUser ? widget.onLongPress : null,
      child: AnimatedScale(
        scale: _pressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 1000),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isCurrentUser
                ? (isDarkMode
                ? Colors.green.shade600
                : Colors.green.shade500)
                : (isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Text(
            widget.message,
            style: TextStyle(
              fontSize: 14.sp,
              color: widget.isCurrentUser
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}