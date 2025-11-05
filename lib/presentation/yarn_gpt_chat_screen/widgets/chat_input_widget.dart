import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './voice_input_widget.dart';

class ChatInputWidget extends StatelessWidget {
  final TextEditingController textController;
  final bool isRecording;
  final VoidCallback onSendMessage;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const ChatInputWidget({
    Key? key,
    required this.textController,
    required this.isRecording,
    required this.onSendMessage,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Ask about your privacy rights...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    suffixIcon: textController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: onSendMessage,
                            child: Container(
                              margin: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: CustomIconWidget(
                                iconName: 'send',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 4.w,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            VoiceInputWidget(
              isRecording: isRecording,
              onStartRecording: onStartRecording,
              onStopRecording: onStopRecording,
            ),
          ],
        ),
      ),
    );
  }
}
