import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.r), // responsive radius
        ),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
        padding: EdgeInsets.all(20.h), // responsive padding
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 24.sp, // responsive icon
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 20.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp, // responsive text
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}