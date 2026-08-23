import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_state.dart';
import 'package:ruya/features/chat/presentation/cubit/voice_input_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/voice_input_state.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_header.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:ruya/l10n/app_localizations.dart';

class AiChatPage extends StatelessWidget {
  final int? initialConversationId;
  final File? initialImage;

  const AiChatPage({
    super.key,
    this.initialConversationId,
    this.initialImage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatCubit>(
          create: (_) {
            final cubit = ChatCubit(
              sendChatMessageUseCase: getIt(),
              getConversationUseCase: getIt(),
              ttsService: getIt(),
              initialConversationId: initialConversationId,
            );
            if (initialImage != null) {
              cubit.selectImage(initialImage);
            }
            return cubit;
          },
        ),
        BlocProvider<VoiceInputCubit>(
          create: (_) => VoiceInputCubit(
            speechToTextService: getIt(),
            ttsService: getIt(),
          ),
        ),
      ],
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      final voiceCubit = context.read<VoiceInputCubit>();
      if (voiceCubit.state.isListening) {
        voiceCubit.cancelListening();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _onSendTypedMessage(BuildContext context) {
    final text = _textController.text.trim();
    final chatCubit = context.read<ChatCubit>();
    final hasImage = chatCubit.state.selectedImage != null;

    if (text.isEmpty && !hasImage) return;

    final lang = Localizations.localeOf(context).languageCode;
    chatCubit.sendMessage(
      text: text,
      isVoice: false,
      language: lang,
    );

    _textController.clear();
    _scrollToBottom();
  }

  Future<void> _onStartVoiceRecording(BuildContext context) async {
    final lang = Localizations.localeOf(context).languageCode;
    await context.read<VoiceInputCubit>().startListening(languageCode: lang);
  }

  Future<void> _onStopVoiceRecording(BuildContext context) async {
    final transcript = await context.read<VoiceInputCubit>().stopListening();
    if (!context.mounted) return;

    if (transcript.isNotEmpty) {
      final lang = Localizations.localeOf(context).languageCode;
      context.read<ChatCubit>().sendMessage(
        text: transcript,
        isVoice: true,
        language: lang,
      );
      _scrollToBottom();
    }
  }

  void _onCancelVoiceRecording(BuildContext context) {
    context.read<VoiceInputCubit>().cancelListening();
  }

  void _showPermissionDialog(BuildContext context, bool permanentlyDenied) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = AppColors.getBrandPrimary(context);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.getSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mic_none_rounded, color: brandColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.micPermissionRequired,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.micPermissionRationale,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.getMutedText(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.getMutedText(context)),
            ),
          ),
          if (permanentlyDenied)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.openSettings),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<VoiceInputCubit, VoiceInputState>(
          listener: (context, state) {
            if (state.status == VoiceInputStatus.permissionDenied) {
              _showPermissionDialog(context, false);
            } else if (state.status == VoiceInputStatus.permissionPermanentlyDenied) {
              _showPermissionDialog(context, true);
            } else if (state.status == VoiceInputStatus.unavailable) {
              AppSnackBar.showError(context, l10n.speechNotAvailable);
            }
          },
        ),
        BlocListener<ChatCubit, ChatState>(
          listenWhen: (prev, curr) =>
              prev.messages.length != curr.messages.length ||
              prev.status != curr.status,
          listener: (context, state) {
            _scrollToBottom();
            if (state.errorMessage != null && state.status == ChatStatus.error) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),
        appBar: _buildAppBar(context, isDark),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.status == ChatStatus.loading && state.messages.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.getBrandPrimary(context),
                      ),
                    );
                  }

                  final lang = Localizations.localeOf(context).languageCode;

                  return ChatMessageList(
                    messages: state.messages,
                    scrollController: _scrollController,
                    currentlyPlayingMessageId: state.currentlyPlayingMessageId,
                    onPlayTts: (msg) =>
                        context.read<ChatCubit>().playTts(msg, language: lang),
                    onStopTts: () => context.read<ChatCubit>().stopTts(),
                    onRetry: (id) =>
                        context.read<ChatCubit>().retryMessage(id, language: lang),
                  );
                },
              ),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, chatState) {
                return BlocBuilder<VoiceInputCubit, VoiceInputState>(
                  builder: (context, voiceState) {
                    return ChatInputBar(
                      controller: _textController,
                      selectedImage: chatState.selectedImage,
                      onClearImage: () => context.read<ChatCubit>().clearImage(),
                      onImageSelected: (File file) =>
                          context.read<ChatCubit>().selectImage(file),
                      isRecording: voiceState.isListening,
                      isMicAvailable: voiceState.isAvailable,
                      liveTranscript: voiceState.transcript,
                      onSend: () => _onSendTypedMessage(context),
                      onStartRecording: () => _onStartVoiceRecording(context),
                      onStopRecording: () => _onStopVoiceRecording(context),
                      onCancelRecording: () => _onCancelVoiceRecording(context),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: AppColors.getSurface(context),
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
          color: isDark ? Colors.white : Colors.black87,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      title: const ChatHeader(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.getDivider(context),
        ),
      ),
    );
  }
}
