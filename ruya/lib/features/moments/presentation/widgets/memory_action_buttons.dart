import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ruya/core/theme/app_colors.dart';
import 'package:ruya/core/utils/app_snackbar.dart';
import 'package:ruya/core/utils/app_spacing.dart';
import 'package:ruya/features/moments/domain/entities/moment_item.dart';
import 'package:ruya/l10n/app_localizations.dart';

class MemoryActionButtons extends StatelessWidget {
  final MomentItem moment;

  const MemoryActionButtons({
    super.key,
    required this.moment,
  });

  Future<void> _shareJourney(BuildContext context) async {
    final text = '✨ Ruya Memory: ${moment.title} (${moment.startDate})\n'
        'Check out my Egyptian heritage journey on Ruya!';
    await Share.share(text, subject: moment.title);
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context pdfContext) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Ruya Travel Keepsake',
                    style: const pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Trip: ${moment.title}',
                  style: const pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('Date: ${moment.startDate}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Total Photos: ${moment.photos.length}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 24),
                pw.Paragraph(
                  text:
                      'Preserved with Ruya AI Egyptian Heritage Travel Companion.',
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'Ruya_${moment.title.replaceAll(' ', '_')}.pdf',
      );

      if (context.mounted) {
        AppSnackBar.showSuccess(context, l10n.pdfSavedSuccess);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding(context),
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          // Primary Share Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _shareJourney(context),
              icon: const Icon(Icons.share_outlined, size: 20),
              label: Text(
                l10n.shareJourney,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getBrandPrimary(context),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          AppSpacing.verticalGapSm,
          // Secondary PDF Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _downloadPdf(context),
              icon: const Icon(Icons.download_outlined, size: 20),
              label: Text(
                l10n.downloadPdf,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.getDivider(context),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
