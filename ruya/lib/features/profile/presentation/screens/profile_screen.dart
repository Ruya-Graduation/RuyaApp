import 'package:flutter/material.dart';
import 'package:ruya/features/profile/presentation/widgets/profile_header.dart';
import 'package:ruya/features/profile/presentation/widgets/account_settings_card.dart';
import 'package:ruya/features/profile/presentation/widgets/app_preferences_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFFD4A373)),
            onPressed: () {},
          )
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(),
            SizedBox(height: 32),
            AccountSettingsCard(),
            SizedBox(height: 16),
            AppPreferencesCard(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
