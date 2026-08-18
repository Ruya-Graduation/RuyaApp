import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ruya/features/booking/domain/entities/booking_entity.dart';
import 'package:screenshot/screenshot.dart';

class TicketExportService {
  final ScreenshotController screenshotController = ScreenshotController();

  /// Captures the ticket widget wrapped with [Screenshot] and saves it
  /// directly to the device's photo gallery via [Gal].
  Future<bool> saveTicketAsImage() async {
    try {
      final permitted =
          await Gal.hasAccess() || await Gal.requestAccess();
      if (!permitted) return false;

      final bytes = await screenshotController.capture(pixelRatio: 3.0);
      if (bytes == null) return false;

      await Gal.putImageBytes(
        bytes,
        name: 'ruya_ticket_${DateTime.now().millisecondsSinceEpoch}',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Builds a crisp, selectable single-page PDF document replicating the
  /// ticket layout and opens the OS share/save sheet via [Printing.sharePdf].
  Future<bool> saveOrShareTicketAsPdf(BookingEntity booking) async {
    try {
      final doc = pw.Document();
      final dateFormatted =
          DateFormat('MMMM d, yyyy').format(booking.visitDate);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(32),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300, width: 1.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Ruya — Entry Ticket',
                        style: const pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.brown800,
                        ),
                      ),
                      pw.Text(
                        'CONFIRMED',
                        style: const pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green700,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Present this document or reference number at the entrance gate.',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 16),
                  _pdfRow('Reference #', booking.referenceNumber),
                  _pdfRow('Site', booking.siteName),
                  _pdfRow('Date', dateFormatted),
                  _pdfRow('Time Slot', booking.timeSlot),
                  _pdfRow('Number of Tickets', '${booking.ticketCount}'),
                  _pdfRow(
                    'Total Price',
                    '${booking.currency} ${booking.totalPrice.toStringAsFixed(0)}',
                  ),
                  pw.SizedBox(height: 16),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 12),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'Thank you for exploring with Ruya!',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final bytes = await doc.save();
      return await Printing.sharePdf(
        bytes: bytes,
        filename: 'ruya_ticket_${booking.referenceNumber}.pdf',
      );
    } catch (_) {
      return false;
    }
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 13, color: PdfColors.grey800),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
