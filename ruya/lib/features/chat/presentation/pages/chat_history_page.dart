import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/features/chat/domain/entities/chat_session.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_history_cubit.dart';
import 'package:ruya/features/chat/presentation/cubit/chat_history_state.dart';
import 'package:ruya/features/chat/presentation/widgets/chat_sessions_list.dart';
import 'package:ruya/features/chat/presentation/widgets/start_conversation_button.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatHistoryCubit(
        getConversationsUseCase: getIt(),
        deleteConversationUseCase: getIt(),
      )..loadConversations(),
      child: const _ChatHistoryView(),
    );
  }
}

class _ChatHistoryView extends StatelessWidget {
  const _ChatHistoryView();

  Future<void> _confirmDelete(
    BuildContext context,
    ChatSession session,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteConfirmDialog(
        l10n: l10n,
      ),
    );

    if (shouldDelete == true && context.mounted) {
      final success = await context
          .read<ChatHistoryCubit>()
          .deleteConversation(session);
      if (!success && context.mounted) {
        AppSnackBar.showError(context, l10n.errorLoadingConversations);
      }
    }
  }

  void _openConversation(BuildContext context, ChatSession session) {
    context.push('/ai-chat', extra: session.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brandColor = AppColors.getBrandPrimary(context);

    return BlocConsumer<ChatHistoryCubit, ChatHistoryState>(
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.status == ChatHistoryStatus.error) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.getBackground(context),
          appBar: _buildAppBar(context, l10n),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RecentConversationsLabel(l10n: l10n),
              Expanded(
                child: RefreshIndicator(
                  color: brandColor,
                  onRefresh: () =>
                      context.read<ChatHistoryCubit>().loadConversations(),
                  child: switch (state.status) {
                    ChatHistoryStatus.initial ||
                    ChatHistoryStatus.loading =>
                      Center(
                        child: CircularProgressIndicator(
                          color: brandColor,
                        ),
                      ),
                    ChatHistoryStatus.error when state.sessions.isEmpty =>
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.errorRed,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage ??
                                  l10n.errorLoadingConversations,
                              style: TextStyle(
                                color: AppColors.getMutedText(context),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: () => context
                                  .read<ChatHistoryCubit>()
                                  .loadConversations(),
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    _ => ChatSessionsList(
                        sessions: state.sessions,
                        onSessionTap: (s) => _openConversation(context, s),
                        onDelete: (s) => _confirmDelete(context, s),
                      ),
                  },
                ),
              ),
              StartConversationButton(
                label: l10n.startNewConversation,
                onPressed: () => context.push('/ai-chat'),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.chatHistory,
        style: const TextStyle(
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.getSurface(context),
      elevation: 0,
      centerTitle: false,
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
class _RecentConversationsLabel extends StatelessWidget {
  final AppLocalizations l10n;

  const _RecentConversationsLabel({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Text(
        l10n.recentConversations,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.getMutedText(context),
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// ── Confirm Delete Dialog ─────────────────────────────────────────────────────
class _DeleteConfirmDialog extends StatelessWidget {
  final AppLocalizations l10n;

  const _DeleteConfirmDialog({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: AppColors.getSurface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.deleteChatConfirmTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      content: Text(
        l10n.deleteChatConfirmBody,
        style: TextStyle(color: AppColors.getMutedText(context)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.getMutedText(context)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
