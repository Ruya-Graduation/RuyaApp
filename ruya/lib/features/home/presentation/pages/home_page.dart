import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/location/location_permission_status.dart';
import 'package:ruya/core/location/location_settings_cubit.dart';
import 'package:ruya/core/location/proximity_event.dart';
import 'package:ruya/core/location/proximity_service.dart';
import 'package:ruya/core/location/site_location.dart';
import 'package:ruya/core/session/session_service.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/home/presentation/cubit/home_cubit.dart';
import 'package:ruya/features/home/presentation/cubit/home_state.dart';
import 'package:ruya/features/home/presentation/widgets/home_filter_chips.dart';
import 'package:ruya/features/home/presentation/widgets/home_monument_list.dart';
import 'package:ruya/features/home/presentation/widgets/home_search_bar.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// The main discovery / home screen.
///
/// Delegates UI to three focused sub-widgets:
///   • [HomeSearchBar]   — search input
///   • [HomeFilterChips] — horizontal scrollable filter row
///   • [HomeMonumentList] — monument cards
///
/// State (loading, loaded, error, selected filter) is managed by [HomeCubit].
///
/// GPS proximity streaming is managed here via [ProximityService]:
///   • Starts once [HomeCubit] emits [HomeStatus.loaded] AND the GPS toggle
///     is ON AND the user is authenticated.
///   • Pauses when the app is backgrounded; resumes on foregrounding.
///
/// ### Tab-switch decision
/// The GPS stream is NOT stopped when the user switches to another bottom-nav
/// tab. Rationale: the user is still in the app (foreground) after the Home
/// tab has loaded, which satisfies the "foreground only" requirement. Stopping
/// on every tab-switch would restart permission flows unnecessarily and create
/// a worse UX for users walking through a site while checking the chat tab.
/// This decision is intentional and reviewable — flag here if it needs to change.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const List<String> _filters = [
    'All',
    'Giza',
    'Luxor',
    'Aswan',
    'Cairo',
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final HomeCubit _homeCubit;
  late final ProximityService _proximityService;
  late final LocationSettingsCubit _locationSettingsCubit;

  StreamSubscription<ProximityEvent>? _proximitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _homeCubit = getIt<HomeCubit>()..loadMonuments();
    _proximityService = getIt<ProximityService>();
    _locationSettingsCubit = getIt<LocationSettingsCubit>();

    // Subscribe to proximity events once; the stream lives for the foreground
    // session. We attach the listener in initState even before start() is
    // called so no events are missed during the brief permission-check window.
    _proximitySubscription = _proximityService.events.listen(
      _onProximityEvent,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Foreground-only: stop tracking when the OS backgrounds the app.
        _proximityService.stop();
      case AppLifecycleState.resumed:
        // Only restart if the toggle is on and the user is still authenticated.
        _maybeStartProximity();
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    _proximitySubscription?.cancel();
    _proximitySubscription = null;
    // Note: we do NOT call _proximityService.stop() here on purpose.
    // Since HomePage lives inside a StatefulShellRoute branch, it is NOT
    // disposed on tab-switch — only on logout/full teardown. The stream
    // should keep running while the app is in the foreground.
    // Logout explicitly calls stop() in account_settings_card.dart.
    WidgetsBinding.instance.removeObserver(this);
    _homeCubit.close();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // GPS helpers
  // ---------------------------------------------------------------------------

  /// Checks session + toggle, updates site list, then starts the stream.
  /// Safe to call multiple times — [ProximityService.start] is idempotent.
  Future<void> _maybeStartProximity() async {
    if (!_locationSettingsCubit.state) return; // toggle is off

    // Re-check session (guards against foregrounding after token expiry).
    final user = await getIt<SessionService>().restoreSession();
    if (user == null) return;

    // Make sure the service has the latest site list.
    _proximityService.updateSites(_buildSiteLocations());

    final status = await _proximityService.start();
    _handlePermissionStatus(status);
  }

  void _handlePermissionStatus(LocationPermissionStatus status) {
    if (!mounted) return;
    switch (status) {
      case LocationPermissionStatus.granted:
        break; // happy path — no UI needed
      case LocationPermissionStatus.serviceDisabled:
        AppSnackBar.showError(
          context,
          'Location services are disabled. Enable GPS in device settings to use proximity alerts.',
        );
      case LocationPermissionStatus.denied:
        AppSnackBar.showError(
          context,
          'Location permission denied. Grant it in settings to enable nearby site alerts.',
        );
      case LocationPermissionStatus.deniedForever:
        AppSnackBar.showError(
          context,
          'Location permission permanently denied. Open device settings to enable it.',
        );
    }
  }

  List<SiteLocation> _buildSiteLocations() {
    return _homeCubit.state.monuments
        .map(
          (m) => SiteLocation(
            id: m.id,
            name: m.name,
            latitude: m.latitude,
            longitude: m.longitude,
          ),
        )
        .toList();
  }

  void _onProximityEvent(ProximityEvent event) {
    if (!mounted) return;
    AppSnackBar.showInfo(
      context,
      '📌 You\'re near ${event.site.name} — take a look!',
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: _homeCubit),
        BlocProvider<LocationSettingsCubit>.value(value: _locationSettingsCubit),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status && curr.status == HomeStatus.loaded,
        listener: (context, state) {
          // Sites just loaded for the first time → attempt to start GPS.
          _maybeStartProximity();
        },
        child: BlocListener<LocationSettingsCubit, bool>(
          listener: (context, gpsEnabled) {
            if (gpsEnabled) {
              _maybeStartProximity();
            } else {
              _proximityService.stop();
            }
          },
          child: const _HomeView(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal view — reads from the BlocProviders above.
// ---------------------------------------------------------------------------

/// Internal view — has access to [HomeCubit] from the tree above.
class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            HomeSearchBar(hint: l10n.searchHint),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (prev, curr) =>
                  prev.selectedFilterIndex != curr.selectedFilterIndex,
              builder: (context, state) {
                return HomeFilterChips(
                  filters: HomePage._filters,
                  selectedIndex: state.selectedFilterIndex,
                  onSelected: context.read<HomeCubit>().selectFilter,
                );
              },
            ),
            AppSpacing.verticalGapLg,
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (prev, curr) =>
                    prev.status != curr.status ||
                    prev.monuments != curr.monuments,
                builder: (context, state) {
                  return switch (state.status) {
                    HomeStatus.initial || HomeStatus.loading =>
                      const Center(child: CircularProgressIndicator()),
                    HomeStatus.error => _ErrorView(
                        message: state.errorMessage ?? 'Something went wrong.',
                        onRetry: () =>
                            context.read<HomeCubit>().loadMonuments(),
                      ),
                    HomeStatus.loaded =>
                      HomeMonumentList(monuments: state.monuments),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when the cubit emits [HomeStatus.error].
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: AppColors.errorRed.withValues(alpha: 0.7),
            ),
            AppSpacing.verticalGapLg,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            AppSpacing.verticalGapLg,
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
