import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const VoiceInputWidget({
    Key? key,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.isRecording ? widget.onStopRecording : widget.onStartRecording,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isRecording ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: widget.isRecording
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(
                    color: widget.isRecording
                        ? AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                    blurRadius: widget.isRecording ? 12 : 8,
                    spreadRadius: widget.isRecording ? 2 : 0,
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: widget.isRecording ? 'stop' : 'mic',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
          );
        },
      ),
    );
  }
}
