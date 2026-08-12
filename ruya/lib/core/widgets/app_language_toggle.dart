import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/localization/locale_cubit.dart';
import 'package:ruya/core/widgets/app_segmented_toggle.dart';

class AppLanguageToggle extends StatelessWidget {
  const AppLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return AppSegmentedToggle<String>(
          options: const ['en', 'ar'],
          selected: locale.languageCode,
          onChanged: (code) {
            context.read<LocaleCubit>().setLocale(Locale(code));
          },
          labelBuilder: (code) => code.toUpperCase(),
        );
      },
    );
  }
}
