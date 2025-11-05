
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/language_indicator_widget.dart';
import './widgets/quick_action_chips_widget.dart';

class YarnGptChatScreen extends StatefulWidget {
  const YarnGptChatScreen({Key? key}) : super(key: key);

  @override
  State<YarnGptChatScreen> createState() => _YarnGptChatScreenState();
}

class _YarnGptChatScreenState extends State<YarnGptChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLoading = false;
  String _currentLanguage = 'EN';

  final List<Map<String, dynamic>> _messages = [
    {
      'id': 1,
      'content':
          'Hello! I\'m YarnGPT, your AI privacy assistant. I can help you understand your data rights, explain consent policies, and guide you through privacy decisions. How can I assist you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
      'audioPath': 'demo_welcome_audio.wav',
      'isPlaying': false,
    }
  ];

  final Map<String, String> _languages = {
    'EN': 'English',
    'IG': 'Igbo',
    'YO': 'Yoruba',
    'HA': 'Hausa',
  };

  final Map<String, List<String>> _demoResponses = {
    'explain my rights': [
      'In Nigeria, you have several fundamental data protection rights under the Nigeria Data Protection Regulation (NDPR). You have the right to know what personal data is collected about you, the right to access your data, the right to correct inaccurate information, and the right to request deletion of your data. You also have the right to withdraw consent at any time and the right to data portability.',
      'demo_rights_explanation.wav'
    ],
    'review recent access': [
      'Based on your recent activity, I can see that 3 organizations have accessed your data in the past 7 days: FirstBank Nigeria accessed your financial profile on November 2nd for loan processing, MTN Nigeria accessed your communication preferences on November 1st for service updates, and Jumia accessed your shopping history on October 31st for personalized recommendations. Would you like me to explain any of these accesses in detail?',
      'demo_recent_access.wav'
    ],
    'help with consent': [
      'I can help you understand and manage your consent preferences. Consent should always be freely given, specific, informed, and unambiguous. You can withdraw consent at any time without affecting the lawfulness of processing based on consent before its withdrawal. Would you like me to review your current consent settings or explain what a specific organization is asking permission for?',
      'demo_consent_help.wav'
    ],
    'default': [
      'I understand you\'re asking about privacy and data protection. As your AI assistant, I can help explain your rights under Nigerian data protection laws, review how organizations are accessing your data, or guide you through consent decisions. Could you be more specific about what you\'d like to know?',
      'demo_default_response.wav'
    ]
  };

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    if (kIsWeb) return;

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Microphone permission is required for voice input'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      await _requestMicrophonePermission();

      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);

        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          final dir = await getTemporaryDirectory();
          String path =
              '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(const RecordConfig(), path: path);
        }
      }
    } catch (e) {
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);

      if (path != null) {
        // Add voice message to chat
        final voiceMessage = {
          'id': _messages.length + 1,
          'content': 'Voice message recorded',
          'isUser': true,
          'timestamp': DateTime.now(),
          'audioPath': path,
          'isPlaying': false,
        };

        setState(() {
          _messages.add(voiceMessage);
        });

        _scrollToBottom();

        // Simulate AI processing voice input
        await Future.delayed(const Duration(milliseconds: 1500));
        _generateAIResponse(
            'I heard your voice message. Could you please type your question so I can provide a more accurate response?');
      }
    } catch (e) {
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = {
      'id': _messages.length + 1,
      'content': _textController.text.trim(),
      'isUser': true,
      'timestamp': DateTime.now(),
      'isPlaying': false,
    };

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    final messageText = _textController.text.trim().toLowerCase();
    _textController.clear();
    _scrollToBottom();

    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _generateAIResponse(messageText);
    });
  }

  void _generateAIResponse(String userInput) {
    String responseKey = 'default';

    // Simple keyword matching for demo responses
    if (userInput.contains('rights') ||
        userInput.contains('explain my rights')) {
      responseKey = 'explain my rights';
    } else if (userInput.contains('access') ||
        userInput.contains('recent') ||
        userInput.contains('review recent access')) {
      responseKey = 'review recent access';
    } else if (userInput.contains('consent') ||
        userInput.contains('help with consent')) {
      responseKey = 'help with consent';
    }

    final response = _demoResponses[responseKey] ?? _demoResponses['default']!;

    final aiMessage = {
      'id': _messages.length + 1,
      'content': response[0],
      'isUser': false,
      'timestamp': DateTime.now(),
      'audioPath': response[1],
      'isPlaying': false,
    };

    setState(() {
      _messages.add(aiMessage);
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _handleQuickAction(String action) {
    _textController.text = action;
    _sendMessage();
  }

  void _playAudio(int messageIndex) {
    setState(() {
      // Stop all other audio
      for (int i = 0; i < _messages.length; i++) {
        _messages[i]['isPlaying'] = false;
      }
      // Toggle current audio
      _messages[messageIndex]['isPlaying'] =
          !(_messages[messageIndex]['isPlaying'] as bool);
    });

    // Simulate audio playback
    if (_messages[messageIndex]['isPlaying'] as bool) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _messages[messageIndex]['isPlaying'] = false;
          });
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Select Language',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 2.h),
            ..._languages.entries.map((entry) => ListTile(
                  leading: CustomIconWidget(
                    iconName: 'language',
                    color: _currentLanguage == entry.key
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  title: Text(
                    entry.value,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: _currentLanguage == entry.key
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: _currentLanguage == entry.key
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  trailing: _currentLanguage == entry.key
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    setState(() => _currentLanguage = entry.key);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConversation() async {
    setState(() => _isLoading = true);

    // Simulate loading conversation history
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conversation refreshed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'YarnGPT Assistant',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          LanguageIndicatorWidget(
            currentLanguage: _currentLanguage,
            onLanguageTap: _showLanguageSelector,
          ),
          SizedBox(width: 4.w),
        ],
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshConversation,
              color: AppTheme.lightTheme.primaryColor,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                      child: Row(
                        children: [
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
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface
                                  .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 4.w,
                                  height: 4.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Thinking...',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ChatMessageWidget(
                    message: _messages[index],
                    onPlayAudio: () => _playAudio(index),
                  );
                },
              ),
            ),
          ),
          QuickActionChipsWidget(
            onChipTap: _handleQuickAction,
          ),
          SizedBox(height: 1.h),
          ChatInputWidget(
            textController: _textController,
            isRecording: _isRecording,
            onSendMessage: _sendMessage,
            onStartRecording: _startRecording,
            onStopRecording: _stopRecording,
          ),
        ],
      ),
    );
  }
}
