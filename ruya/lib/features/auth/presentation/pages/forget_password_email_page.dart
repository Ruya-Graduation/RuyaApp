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

class ForgetPasswordEmailPage extends StatefulWidget {
  const ForgetPasswordEmailPage({super.key});

  @override
  State<ForgetPasswordEmailPage> createState() =>
      _ForgetPasswordEmailPageState();
}

class _ForgetPasswordEmailPageState extends State<ForgetPasswordEmailPage> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text;

    final error = Validators.email(email, l10n.invalidEmailError);
    setState(() {
      _emailError = error;
    });

    if (error == null) {
      context.read<ForgetPasswordCubit>().requestOtp(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // BlocProvider is supplied by the ShellRoute in app_router.dart —
    // do NOT create another one here; that would lose the email state
    // when the user navigates to the OTP page.
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
                        context.push(
                          '/verify-otp',
                          extra: _emailController.text,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          state.status == ForgetPasswordStatus.loading;

                      return Column(
                        children: [
                          Text(
                            l10n.forgetPasswordTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getBrandPrimary(context),
                            ),
                          ),
                          AppSpacing.verticalGapLg,
                          Text(
                            l10n.forgetPasswordSubtitle,
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
                          AppTextField(
                            label: l10n.emailAddressLabel,
                            hint: 'ahmed@example.com',
                            controller: _emailController,
                            errorText: _emailError,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          AppSpacing.verticalGapXxl,
                          AppPrimaryButton(
                            label: l10n.recoverPasswordBtn,
                            isLoading: isLoading,
                            onPressed: () => _submit(context),
                          ),
                          AppSpacing.verticalGapLg,
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              l10n.backToSignIn,
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
