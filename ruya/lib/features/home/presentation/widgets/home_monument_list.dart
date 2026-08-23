import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/presentation/widgets/monument_card.dart';
import 'package:ruya/l10n/app_localizations.dart';

/// Displays a scrollable list of [MonumentCard] widgets.
/// Separated from [HomePage] so it can be tested and replaced independently.
class HomeMonumentList extends StatelessWidget {
  final List<MonumentEntity> monuments;

  const HomeMonumentList({
    super.key,
    required this.monuments,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (monuments.isEmpty) {
      return Center(
        child: Text(
          l10n.noMonumentsFound,
          style: TextStyle(color: AppColors.getMutedText(context)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: monuments.length,
      itemBuilder: (context, index) {
        return MonumentCard(monument: monuments[index]);
      },
    );
  }
}
