import 'package:flutter/material.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_app_bar.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_bottom_sheet.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_info_grid.dart';
import 'package:ruya/features/site_details/presentation/widgets/site_suggests_banner.dart';

class SiteDetailsScreen extends StatelessWidget {
  const SiteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF8F5),
      body: CustomScrollView(
        slivers: [
          const SiteAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karnak Temple Complex',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay', // Assuming a serif font is used based on UI
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Luxor, Upper Egypt — Est. 2055 BCE',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SiteInfoGrid(),
                  const SizedBox(height: 24),
                  const SiteSuggestsBanner(),
                  const SizedBox(height: 24),
                  Text(
                    'The Karnak Temple Complex is a vast ancient religious site near Luxor, spanning over 2km². It was built over 2,000 years by generations of pharaohs, making it one of the largest religious structures ever built...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: const SiteBottomSheet(),
    );
  }
}
