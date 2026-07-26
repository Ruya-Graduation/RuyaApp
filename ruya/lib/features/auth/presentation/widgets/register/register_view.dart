import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/utils/validators.dart';
import 'package:ruya/core/widgets/app_alert_banner.dart';

import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/features/auth/presentation/cubit/register_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/register_state.dart';
import 'package:ruya/features/auth/presentation/widgets/register/register_form_fields.dart';
import 'package:ruya/l10n/app_localizations.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final nameError = Validators.name(name, l10n.fullNameRequiredError);
    final emailError = Validators.email(email, l10n.invalidEmailError);
    final passwordError = Validators.password(password, l10n.passwordMinError);

    final cubit = context.read<RegisterCubit>();
    if (nameError != null || emailError != null || passwordError != null) {
      cubit.validateFields({
        'name': nameError,
        'email': emailError,
        'password': passwordError,
      });
    } else {
      cubit.register(name, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (context.mounted) {
              context.go('/explore');
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state.status == RegisterStatus.loading || state.status == RegisterStatus.success;
        final isSuccess = state.status == RegisterStatus.success;

        return Column(
          children: [
            if (state.errorMessage != null && !isSuccess) ...[
              AppAlertBanner(
                title: state.errorMessage!,
                isError: true,
              ),
              AppSpacing.verticalGapLg,
            ],
            if (state.fieldErrors.values.any((e) => e != null)) ...[
              AppAlertBanner(
                title: l10n.fixErrorsBanner,
                isError: true,
              ),
              AppSpacing.verticalGapLg,
            ],
            if (isSuccess) ...[
              AppAlertBanner(
                title: l10n.accountCreatedTitle,
                subtitle: l10n.accountCreatedSubtitle,
                isError: false,
              ),
              AppSpacing.verticalGapLg,
            ],
            RegisterFormFields(
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
              nameError: state.fieldErrors['name'],
              emailError: state.fieldErrors['email'],
              passwordError: state.fieldErrors['password'],
              isSuccess: isSuccess,
            ),
            AppSpacing.verticalGapXl,
            AppPrimaryButton(
              label: isSuccess
                  ? l10n.creatingAccount
                  : isLoading
                      ? l10n.creatingAccount
                      : l10n.createAccount,
              isLoading: isLoading,
              onPressed: () => _submit(context),
            ),
            if (isLoading) ...[
              AppSpacing.verticalGapMd,
              _buildStepIndicator(l10n),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStepIndicator(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.settingUpProfile,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        AppSpacing.verticalGapSm,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(true),
            AppSpacing.horizontalGapXs,
            _dot(false),
            AppSpacing.horizontalGapXs,
            _dot(false),
          ],
        ),
      ],
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.teal : Colors.teal.withValues(alpha: 0.3),
      ),
    );
  }
}
