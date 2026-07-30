import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
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
///   • [HomeSearchBar]  — search input
///   • [HomeFilterChips] — horizontal scrollable filter row
///   • [HomeMonumentList] — monument cards
///
/// State (loading, loaded, error, selected filter) is managed by [HomeCubit].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> _filters = [
    'All',
    'Giza',
    'Luxor',
    'Aswan',
    'Cairo',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadMonuments(),
      child: const _HomeView(),
    );
  }
}

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
