import 'package:flutter/material.dart';
import 'package:ruya/features/home/presentation/widgets/monument_image.dart';

class SiteAppBar extends StatelessWidget {
  final String? imageUrl;

  const SiteAppBar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: MonumentImage(
          imageUrl: imageUrl,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_outline,
              color: Colors.black,
              size: 20,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
