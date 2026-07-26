import 'package:flutter/material.dart';
import 'package:ruya/core/widgets/app_segmented_toggle.dart';
import 'package:ruya/l10n/app_localizations.dart';

class AuthTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AuthTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AppSegmentedToggle<int>(
      options: const [0, 1],
      selected: selectedIndex,
      onChanged: onChanged,
      labelBuilder: (index) => index == 0 ? l10n.signIn : l10n.createAccount,
      variant: ToggleVariant.surface,
    );
  }
}
