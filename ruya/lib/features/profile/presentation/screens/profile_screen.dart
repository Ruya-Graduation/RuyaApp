import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/profile/presentation/widgets/account_settings_card.dart';
import 'package:ruya/features/profile/presentation/widgets/app_preferences_card.dart';
import 'package:ruya/features/profile/presentation/widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.getBrandPrimary(context),
            ),
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
