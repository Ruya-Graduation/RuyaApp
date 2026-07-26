import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_text_field.dart';
import 'package:ruya/l10n/app_localizations.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final bool isSuccess;

  const RegisterFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        AppTextField(
          label: l10n.fullNameLabel,
          hint: l10n.fullNameHint,
          controller: nameController,
          errorText: nameError,
          isSuccess: isSuccess,
        ),
        AppSpacing.verticalGapLg,
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
      ],
    );
  }
}
