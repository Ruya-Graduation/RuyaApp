import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/utils/validators.dart';
import 'package:ruya/core/widgets/app_alert_banner.dart';
import 'package:ruya/core/widgets/app_linear_progress_loader.dart';
import 'package:ruya/core/widgets/app_primary_button.dart';
import 'package:ruya/core/widgets/social_login_row.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_state.dart';
import 'package:ruya/features/auth/presentation/widgets/sign_in/sign_in_form_fields.dart';
import 'package:ruya/l10n/app_localizations.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text;
    final password = _passwordController.text;

    final emailError = Validators.email(email, l10n.invalidEmailError);
    final passwordError = Validators.password(password, l10n.passwordMinError);

    final cubit = context.read<SignInCubit>();
    if (emailError != null || passwordError != null) {
      cubit.validateFields({
        'email': emailError,
        'password': passwordError,
      });
    } else {
      cubit.signIn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.success) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (context.mounted) {
              context.go('/home');
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignInStatus.loading || state.status == SignInStatus.success;
        final isSuccess = state.status == SignInStatus.success;

        return Column(
          children: [
            if (state.errorMessage != null && !isSuccess) ...[
              AppAlertBanner(
                title: l10n.incorrectCredentialsTitle,
                subtitle: l10n.incorrectCredentialsSubtitle,
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
                title: l10n.welcomeBack(state.user?.name ?? ''),
                subtitle: l10n.signInSuccessSubtitle,
                isError: false,
              ),
              AppSpacing.verticalGapLg,
            ],
            SignInFormFields(
              emailController: _emailController,
              passwordController: _passwordController,
              emailError: state.fieldErrors['email'],
              passwordError: state.fieldErrors['password'],
              isSuccess: isSuccess,
            ),
            AppSpacing.verticalGapXl,
            AppPrimaryButton(
              label: state.status == SignInStatus.error && state.errorMessage != null
                  ? l10n.tryAgain
                  : isSuccess
                      ? l10n.signingIn
                      : isLoading
                          ? l10n.signingIn
                          : l10n.signIn,
              isLoading: isLoading,
              onPressed: () => _submit(context),
            ),
            if (isLoading) ...[
              AppSpacing.verticalGapMd,
              AppLinearProgressLoader(caption: l10n.loadingJourney),
            ],
            if (!isLoading && !isSuccess) ...[
              AppSpacing.verticalGapXxl,
              SocialLoginRow(dividerText: l10n.orContinueWith),
              AppSpacing.verticalGapXxl,
              AppPrimaryButton(
                label: l10n.continueAsGuest,
                isOutlined: true,
                onPressed: () {},
              ),
            ],
          ],
        );
      },
    );
  }
}
