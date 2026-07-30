import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_alert_banner.dart';
import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_state.dart';
import 'package:ruya/features/auth/presentation/widgets/shared/auth_hero_header.dart';
import 'package:ruya/l10n/app_localizations.dart';

class ForgetPasswordOtpPage extends StatefulWidget {
  final String email;

  const ForgetPasswordOtpPage({super.key, required this.email});

  @override
  State<ForgetPasswordOtpPage> createState() => _ForgetPasswordOtpPageState();
}

class _ForgetPasswordOtpPageState extends State<ForgetPasswordOtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _submit(BuildContext context) {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      context.read<ForgetPasswordCubit>().verifyOtp(otp);
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
                      if (state.status == ForgetPasswordStatus.success) {
                        context.push('/reset-password');
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          state.status == ForgetPasswordStatus.loading;

                      return Column(
                        children: [
                          Text(
                            l10n.getYourCodeTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getBrandPrimary(context),
                            ),
                          ),
                          AppSpacing.verticalGapLg,
                          Text(
                            l10n.getYourCodeSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
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
                          _OtpInputRow(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                          ),
                          AppSpacing.verticalGapXl,
                          _ResendRow(l10n: l10n),
                          AppSpacing.verticalGapXxl,
                          AppPrimaryButton(
                            label: l10n.verifyAndProceedBtn,
                            isLoading: isLoading,
                            onPressed: () => _submit(context),
                          ),
                          AppSpacing.verticalGapLg,
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              l10n.back,
                              style: const TextStyle(color: Colors.grey),
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

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.getBrandPrimary(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}

class _ResendRow extends StatelessWidget {
  final AppLocalizations l10n;
  const _ResendRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.resendCodeText,
          style: const TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          onTap: () {
            // TODO: wire up resend OTP action
          },
          child: Text(
            l10n.resendCodeLink,
            style: TextStyle(
              color: AppColors.getBrandPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
