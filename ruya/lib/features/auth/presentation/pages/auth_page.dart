import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/auth/presentation/cubit/register_cubit.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:ruya/features/auth/presentation/widgets/register/register_view.dart';
import 'package:ruya/features/auth/presentation/widgets/shared/auth_hero_header.dart';
import 'package:ruya/features/auth/presentation/widgets/shared/auth_tab_switcher.dart';
import 'package:ruya/features/auth/presentation/widgets/sign_in/sign_in_view.dart';
import 'package:ruya/l10n/app_localizations.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SignInCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
      ],
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F6),
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
              AuthTabSwitcher(
                selectedIndex: _tabIndex,
                onChanged: (index) {
                  setState(() {
                    _tabIndex = index;
                  });
                },
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _tabIndex == 0
                          ? const SignInView(key: ValueKey(0))
                          : const RegisterView(key: ValueKey(1)),
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalGapXxl,
            ],
          ),
        ),
      ),
    );
  }
}
