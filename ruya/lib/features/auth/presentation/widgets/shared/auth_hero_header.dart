import 'package:flutter/material.dart';
import 'package:ruya/core/theme/app_text_styles.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/core/localization/locale_cubit.dart';
import 'package:ruya/core/widgets/app_segmented_toggle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthHeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String? backgroundAsset;

  const AuthHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.backgroundAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: backgroundAsset != null
            ? DecorationImage(
                image: AssetImage(backgroundAsset!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: DecoratedBox(
        // Gradient overlay: transparent at top → dark at bottom for text clarity
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
            colors: [
              Color(0x00000000), // fully transparent
              Color(0x55000000), // subtle mid
              Color(0xCC000000), // strong at bottom
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocaleToggle(context),
                const Spacer(),
                Text(
                  tag,
                  style: AppTextStyles.heroTagline(context),
                ),
                AppSpacing.verticalGapXs,
                Text(
                  title,
                  style: AppTextStyles.heroTitle(context).copyWith(color: Colors.white),
                ),
                AppSpacing.verticalGapXxs,
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildLocaleToggle(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return Align(
          alignment: AlignmentDirectional.topStart,
          child: AppSegmentedToggle<String>(
            options: const ['en', 'ar'],
            selected: locale.languageCode,
            onChanged: (code) {
              context.read<LocaleCubit>().setLocale(Locale(code));
            },
            labelBuilder: (code) => code.toUpperCase(),
          ),
        );
      },
    );
  }
}
