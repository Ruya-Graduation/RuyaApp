import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/location/location_settings_cubit.dart';
import 'package:ruya/core/widgets/app_language_toggle.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Preferences card shown on the Profile screen.
///
/// Reads [LocationSettingsCubit] directly from the DI container (option a —
/// avoids threading the cubit through the widget tree). The cubit is a
/// LazySingleton so this card and [HomePage] share the same toggle state.
class AppPreferencesCard extends StatelessWidget {
  const AppPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    // Provide the cubit from DI so this pure StatelessWidget stays simple.
    return BlocProvider<LocationSettingsCubit>.value(
      value: getIt<LocationSettingsCubit>(),
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
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
                      color: const Color(0xFFD4A373),
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
                          color: const Color(0xFFD4A373).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.language,
                          color: Color(0xFFD4A373),
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
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
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
                                color: Colors.grey,
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
                            activeThumbColor: const Color(0xFFD4A373),
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
