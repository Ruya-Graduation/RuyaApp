import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_text_field.dart';
import 'package:ruya/l10n/app_localizations.dart';

class SignInFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool isSuccess;

  const SignInFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppTextField(
          label: l10n.emailLabel,
          hint: l10n.emailHint,
          controller: emailController,
          errorText: emailError,
          isSuccess: isSuccess,
          keyboardType: TextInputType.emailAddress,
        ),
        AppSpacing.verticalGapLg,
        AppTextField(
          label: l10n.passwordLabel,
          hint: '••••••••',
          isPassword: true,
          controller: passwordController,
          errorText: passwordError,
          isSuccess: isSuccess,
        ),
        AppSpacing.verticalGapSm,
        TextButton(
          onPressed: () {
            context.push('/forgot-password');
          },
          child: Text(
            l10n.forgotPassword,
            style: TextStyle(color: AppColors.getMutedText(context)),
          ),
        ),
      ],
    );
  }
}
