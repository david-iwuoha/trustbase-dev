import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onPlayAudio;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.onPlayAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = message['isUser'] as bool;
    final String content = message['content'] as String;
    final String? audioPath = message['audioPath'] as String?;
    final bool isPlaying = message['isPlaying'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 75.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (audioPath != null) ...[
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: onPlayAudio,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: isPlaying ? 'pause' : 'play_arrow',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              isPlaying ? 'Playing...' : 'Play Audio',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
