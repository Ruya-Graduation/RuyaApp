import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/location/proximity_service.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ruya/features/profile/presentation/widgets/editable_list_tile.dart';
import 'package:ruya/l10n/app_localizations.dart';

class AccountSettingsCard extends StatelessWidget {
  const AccountSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.accountSettings.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.getBrandPrimary(context),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.getBrandPrimary(context).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                color: AppColors.getBrandPrimary(context),
                size: 20,
              ),
            ),
            title: Text(
              l10n.myBookings,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: AppColors.getMutedText(context),
            ),
            onTap: () => context.push('/my-bookings'),
          ),
          Divider(
            height: 1,
            color: AppColors.getDivider(context),
          ),
          EditableListTile(
            title: l10n.editDisplayName,
            initialValue: 'Ahmed Hassan',
            leadingIcon: Icons.person_outline,
            onSave: (val) {},
          ),
          EditableListTile(
            title: l10n.updateEmail,
            initialValue: 'ahmed@example.com',
            leadingIcon: Icons.language,
            onSave: (val) {},
          ),
          EditableListTile(
            title: l10n.changePassword,
            initialValue: '********',
            leadingIcon: Icons.remove_red_eye_outlined,
            onSave: (val) {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Stop GPS stream immediately on logout — don't rely on
                  // widget disposal since Home branch stays alive in the shell.
                  getIt<ProximityService>().stop();
                  await getIt<LogoutUseCase>()();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.getErrorContainer(context),
                  foregroundColor: AppColors.getOnErrorContainer(context),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.secureLogOut,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
