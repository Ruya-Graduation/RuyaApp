import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_segmented_toggle.dart';
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
  final String selectedLanguage;
  final String selectedKnowledgeLevel;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onKnowledgeLevelChanged;

  const RegisterFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.selectedLanguage,
    required this.selectedKnowledgeLevel,
    required this.onLanguageChanged,
    required this.onKnowledgeLevelChanged,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        AppSpacing.verticalGapLg,
        // ── Preferred Language ───────────────────────────────────────────────
        Text(
          l10n.preferredLanguageLabel,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        AppSpacing.verticalGapSm,
        AppSegmentedToggle<String>(
          options: const ['en', 'ar'],
          selected: selectedLanguage,
          onChanged: onLanguageChanged,
          labelBuilder: (v) => v == 'en' ? 'EN' : 'AR',
          variant: ToggleVariant.surface,
        ),
        AppSpacing.verticalGapLg,
        // ── Knowledge Level ──────────────────────────────────────────────────
        Text(
          l10n.knowledgeLevelLabel,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        AppSpacing.verticalGapSm,
        AppSegmentedToggle<String>(
          options: const ['beginner', 'intermediate', 'advanced'],
          selected: selectedKnowledgeLevel,
          onChanged: onKnowledgeLevelChanged,
          labelBuilder: (v) {
            switch (v) {
              case 'beginner':
                return l10n.knowledgeLevelBeginner;
              case 'intermediate':
                return l10n.knowledgeLevelIntermediate;
              case 'advanced':
                return l10n.knowledgeLevelAdvanced;
              default:
                return v;
            }
          },
          variant: ToggleVariant.surface,
        ),
      ],
    );
  }
}
