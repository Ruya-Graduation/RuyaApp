import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/utils/validators.dart';
import 'package:ruya/core/widgets/app_alert_banner.dart';
import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/core/widgets/app_text_field.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_state.dart';
import 'package:ruya/features/auth/presentation/widgets/shared/auth_hero_header.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ForgetPasswordResetPage extends StatefulWidget {
  const ForgetPasswordResetPage({super.key});

  @override
  State<ForgetPasswordResetPage> createState() =>
      _ForgetPasswordResetPageState();
}

class _ForgetPasswordResetPageState extends State<ForgetPasswordResetPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _newPasswordError;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final error = Validators.password(newPassword, l10n.passwordMinError);
    setState(() {
      _newPasswordError = error;
    });

    if (error == null) {
      context
          .read<ForgetPasswordCubit>()
          .resetPassword(newPassword, confirmPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // BlocProvider is supplied by the ShellRoute in app_router.dart.
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthHeroHeader(
              title: l10n.appName,
              subtitle: l10n.appSubtitle,
              tag: l10n.appTagline,
              backgroundAsset: 'assets/images/egyptian_pyramids.png',
            ),
            AppSpacing.verticalGapLg,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding(context),
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxAuthCardWidth,
                  ),
                  child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                    listener: (context, state) {
                      // Only react to success AFTER resetPassword (step 3).
                      // verifyOtp (step 2) also emits success, but at that
                      // point resetToken is set and we are NOT on this page yet.
                      // Here we guard: resetToken must be present (set by step 2)
                      // and status must be success — meaning step 3 just finished.
                      if (state.status == ForgetPasswordStatus.success &&
                          state.resetToken != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.passwordResetSuccess),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Small delay so the SnackBar flashes briefly before
                        // we navigate away.
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (context.mounted) {
                            // go('/') lands on the AuthPage (sign-in tab).
                            // The session-restore redirect is a no-op here
                            // because reset-password does NOT issue a JWT.
                            context.go('/');
                          }
                        });
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          state.status == ForgetPasswordStatus.loading;

                      return Column(
                        children: [
                          Text(
                            l10n.enterNewPasswordTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getBrandPrimary(context),
                            ),
                          ),
                          AppSpacing.verticalGapLg,
                          Text(
                            l10n.enterNewPasswordSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.getMutedText(context),
                              fontSize: 16,
                            ),
                          ),
                          AppSpacing.verticalGapXxl,
                          if (state.errorMessage != null) ...[
                            AppAlertBanner(
                              title: state.errorMessage!,
                              isError: true,
                            ),
                            AppSpacing.verticalGapLg,
                          ],
                          AppTextField(
                            label: l10n.passwordLabel,
                            hint: '••••••••',
                            isPassword: true,
                            controller: _newPasswordController,
                            errorText: _newPasswordError,
                          ),
                          AppSpacing.verticalGapLg,
                          AppTextField(
                            label: l10n.confirmPasswordLabel,
                            hint: '••••••••',
                            isPassword: true,
                            controller: _confirmPasswordController,
                          ),
                          AppSpacing.verticalGapXxl,
                          AppPrimaryButton(
                            label: l10n.continueBtn,
                            isLoading: isLoading,
                            onPressed: () => _submit(context),
                          ),
                          AppSpacing.verticalGapLg,
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              l10n.back,
                              style: TextStyle(
                                color: AppColors.getMutedText(context),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
