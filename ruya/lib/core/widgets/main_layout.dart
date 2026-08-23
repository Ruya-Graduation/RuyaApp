import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/presentation/cubit/bottom_nav_cubit.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  void _onItemTapped(int index, BuildContext context) {
    context.read<BottomNavCubit>().updateIndex(index);
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          // Sync cubit state with actual navigation shell state
          if (currentIndex != navigationShell.currentIndex) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
               context.read<BottomNavCubit>().updateIndex(navigationShell.currentIndex);
             });
          }
          
          return BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: AppColors.getSurface(context),
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildTabItem(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: l10n.tabDiscover,
                  currentIndex: currentIndex,
                ),
                _buildTabItem(
                  context,
                  index: 1,
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: l10n.tabChat,
                  currentIndex: currentIndex,
                ),
                const SizedBox(width: 48), // Space for FAB
                _buildTabItem(
                  context,
                  index: 2,
                  icon: Icons.auto_stories_outlined,
                  activeIcon: Icons.auto_stories,
                  label: l10n.tabMemories,
                  currentIndex: currentIndex,
                ),
                _buildTabItem(
                  context,
                  index: 3,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: l10n.tabProfile,
                  currentIndex: currentIndex,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/camera-scanner');
        },
        backgroundColor: AppColors.getBrandPrimary(context),
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? AppColors.getBrandPrimary(context)
        : AppColors.getMutedText(context);

    return InkWell(
      onTap: () => _onItemTapped(index, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
