import 'package:flutter/material.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/widgets/app_social_button.dart';

class SocialLoginRow extends StatelessWidget {
  final String dividerText;

  const SocialLoginRow({super.key, required this.dividerText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                dividerText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
          ],
        ),
        AppSpacing.verticalGapLg,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSocialButton(
              icon: const Icon(Icons.g_mobiledata, size: 32),
              onPressed: () {},
            ),
            AppSpacing.horizontalGapLg,
            AppSocialButton(
              icon: const Icon(Icons.facebook, size: 28, color: Colors.blue),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
