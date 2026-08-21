import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_state.dart';
import 'package:ruya/features/moments/presentation/widgets/moment_card.dart';
import 'package:ruya/features/moments/presentation/widgets/moments_header.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MomentsPage extends StatelessWidget {
  const MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: BlocBuilder<MomentsCubit, MomentsState>(
          builder: (context, state) {
            if (state.status == MomentsStatus.loading && state.moments.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.brandPrimaryLight,
                ),
              );
            }

            final moments = state.moments;

            return RefreshIndicator(
              color: AppColors.brandPrimaryLight,
              onRefresh: () => context.read<MomentsCubit>().loadMoments(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: MomentsHeader(totalTrips: moments.length),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pagePadding(context),
                      vertical: AppSpacing.xs,
                    ),
                    sliver: moments.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 48),
                                child: Text(
                                  l10n.noPhotosAddedYet,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.82,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final moment = moments[index];
                                return MomentCard(
                                  moment: moment,
                                  onTap: () {
                                    context
                                        .read<MomentsCubit>()
                                        .selectMoment(moment);
                                    context.push(
                                      '/moments/details/${moment.id}',
                                      extra: moment,
                                    );
                                  },
                                );
                              },
                              childCount: moments.length,
                            ),
                          ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80), // Padding for bottom navbar
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FloatingActionButton(
          heroTag: 'add_moment_fab',
          onPressed: () {
            context.push('/moments/add');
          },
          backgroundColor: AppColors.getBrandPrimary(context),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          tooltip: l10n.addNewMoment,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
