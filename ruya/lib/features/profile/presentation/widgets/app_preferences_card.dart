import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/location/location_settings_cubit.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/theme/theme_cubit.dart';
import 'package:ruya/core/widgets/app_language_toggle.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Preferences card shown on the Profile screen.
class AppPreferencesCard extends StatelessWidget {
  const AppPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDarkModeActive = context.watch<ThemeCubit>().state == ThemeMode.dark;

    // Provide the cubit from DI so this pure StatelessWidget stays simple.
    return BlocProvider<LocationSettingsCubit>.value(
      value: getIt<LocationSettingsCubit>(),
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.getDivider(context),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.appPreferences.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.getBrandPrimary(context),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getBrandPrimary(context).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.language,
                          color: AppColors.getBrandPrimary(context),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          l10n.language,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const AppLanguageToggle(),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: AppColors.getDivider(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.purple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          l10n.darkMode,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Switch(
                        value: isDarkModeActive,
                        onChanged: (_) => context.read<ThemeCubit>().toggle(),
                        activeThumbColor: AppColors.getBrandPrimary(context),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: AppColors.getDivider(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.gpsNarration,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              l10n.autoNarrateNearSites,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.getMutedText(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Reads live state and writes back via the same singleton cubit.
                      BlocBuilder<LocationSettingsCubit, bool>(
                        builder: (context, gpsEnabled) {
                          return Switch(
                            value: gpsEnabled,
                            onChanged: (val) =>
                                context.read<LocationSettingsCubit>().setGpsEnabled(val),
                            activeThumbColor: AppColors.getBrandPrimary(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
