import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';
import 'package:ruya/features/site_details/presentation/cubit/site_details_cubit.dart';
import 'package:ruya/features/site_details/presentation/cubit/site_details_state.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_app_bar.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_bottom_sheet.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_info_grid.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_suggests_banner.dart';

class SiteDetailsScreen extends StatefulWidget {
  final String siteId;

  const SiteDetailsScreen({super.key, required this.siteId});

  @override
  State<SiteDetailsScreen> createState() => _SiteDetailsScreenState();
}

class _SiteDetailsScreenState extends State<SiteDetailsScreen> {
  late final SiteDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SiteDetailsCubit>()..loadSite(widget.siteId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),
        body: BlocBuilder<SiteDetailsCubit, SiteDetailsState>(
          builder: (context, state) {
            return switch (state.status) {
              SiteDetailsStatus.initial ||
              SiteDetailsStatus.loading =>
                const Center(child: CircularProgressIndicator()),
              SiteDetailsStatus.error => _ErrorView(
                  message: state.errorMessage ?? 'Failed to load site details.',
                  onRetry: () => _cubit.loadSite(widget.siteId),
                ),
              SiteDetailsStatus.loaded => _LoadedSiteDetailsView(
                  site: state.site!,
                ),
            };
          },
        ),
        bottomSheet: BlocBuilder<SiteDetailsCubit, SiteDetailsState>(
          builder: (context, state) {
            if (state.status == SiteDetailsStatus.loaded && state.site != null) {
              return SiteBottomSheet(site: state.site!);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _LoadedSiteDetailsView extends StatelessWidget {
  final SiteDetailEntity site;

  const _LoadedSiteDetailsView({required this.site});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationText = [site.city, site.country]
        .where((s) => s.trim().isNotEmpty)
        .join(', ');

    return CustomScrollView(
      slivers: [
        SiteAppBar(imageUrl: site.imageUrl),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                if (locationText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.getMutedText(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.getMutedText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SiteInfoGrid(site: site),
                const SizedBox(height: 24),
                const SiteSuggestsBanner(),
                if (site.description.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    site.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.getMutedText(context),
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
              style: TextStyle(
                color: AppColors.getMutedText(context),
                fontSize: 15,
              ),
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
