import 'package:flutter/material.dart';
import 'package:ruya/features/home/domain/entities/monument_entity.dart';
import 'package:ruya/features/home/presentation/widgets/monument_card.dart';

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
    if (monuments.isEmpty) {
      return const Center(
        child: Text(
          'No monuments found.',
          style: TextStyle(color: Colors.grey),
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
