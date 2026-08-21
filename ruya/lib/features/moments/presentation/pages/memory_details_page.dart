import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_cubit.dart';
import 'package:ruya/features/moments/presentation/cubit/moments_state.dart';
import 'package:ruya/features/moments/presentation/widgets/memory_action_buttons.dart';
import 'package:ruya/features/moments/presentation/widgets/memory_hero_header.dart';
import 'package:ruya/features/moments/presentation/widgets/memory_timeline_gallery.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MemoryDetailsPage extends StatefulWidget {
  final String momentId;
  final MomentItem? initialMoment;

  const MemoryDetailsPage({
    super.key,
    required this.momentId,
    this.initialMoment,
  });

  @override
  State<MemoryDetailsPage> createState() => _MemoryDetailsPageState();
}

class _MemoryDetailsPageState extends State<MemoryDetailsPage> {
  @override
  void initState() {
    super.initState();
    final parsedId = int.tryParse(widget.momentId);
    if (parsedId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<MomentsCubit>().loadMomentDetails(parsedId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedId = int.tryParse(widget.momentId) ?? -1;

    return BlocBuilder<MomentsCubit, MomentsState>(
      builder: (context, state) {
        MomentItem? foundMoment;
        for (final m in state.moments) {
          if (m.id == parsedId) {
            foundMoment = m;
            break;
          }
        }

        final moment = foundMoment ??
            (state.selectedMoment?.id == parsedId
                ? state.selectedMoment
                : null) ??
            widget.initialMoment ??
            MomentItem(
              id: parsedId,
              title: 'Memory Detail',
              startDate: '',
              coverImageUrl: null,
              photoCount: 0,
              createdAt: DateTime.now(),
            );

        return Scaffold(
          backgroundColor: AppColors.getBackground(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Header with Cover Photo and Title
                MemoryHeroHeader(
                  moment: moment,
                  onEdit: () => context.push('/moments/edit', extra: moment),
                ),
                AppSpacing.verticalGapLg,
                // Timeline Gallery Row with delete capability
                MemoryTimelineGallery(
                  photos: moment.photos,
                  onDeletePhoto: (photo) async {
                    final l10n = AppLocalizations.of(context)!;
                    final success = await context
                        .read<MomentsCubit>()
                        .deletePhotoFromAlbum(moment.id, photo.id);
                    if (context.mounted && success) {
                      AppSnackBar.showSuccess(
                        context,
                        l10n.photoDeletedSuccess,
                      );
                    }
                  },
                ),
                AppSpacing.verticalGapLg,
                // Action Buttons (Share & PDF)
                MemoryActionButtons(moment: moment),
                AppSpacing.verticalGapXl,
              ],
            ),
          ),
        );
      },
    );
  }
}
