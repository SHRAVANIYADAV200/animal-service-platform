import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final Map booking;
  final List medications;
  final List charges;
  final double totalCharge;

  const ReceiptScreen({
    super.key,
    required this.booking,
    required this.medications,
    required this.charges,
    required this.totalCharge,
  });

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    final date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Animal Service Platform", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.Text("RECEIPT", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Service: ${booking['serviceType'] ?? "Consultation"}"),
                        pw.Text("Patient: ${booking['farmerEmail'] ?? "N/A"}"),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Date: $date"),
                        pw.Text("Invoice #: ${booking['id'] ?? '0000'}"),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text("Bill Summary", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                if (medications.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Text("Medications:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ...medications.map((m) => pw.Bullet(text: m['content'] ?? "")),
                ],
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headers: ['Description', 'Amount'],
                  data: [
                    ...charges.map((c) => ["Consultation Charge", "Rs. ${c['content'] ?? '0'}"]),
                    ["Total Amount", "Rs. ${totalCharge.toStringAsFixed(2)}"],
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Center(child: pw.Text("Thank you for using our service!", style: const pw.TextStyle(fontStyle: pw.FontStyle.italic))),
              ],
            ),
          );
        },
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Receipt_${booking['id'] ?? 'bill'}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Consultation Bill"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePdf(context),
            tooltip: "Download PDF",
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.white, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      "PAYMENT RECEIPT",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text("Transaction Date: $date", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(32),
                  shrinkWrap: true,
                  children: [
                    _infoRow("Service Type", booking['serviceType'] ?? "General"),
                    _infoRow("Patient ID", booking['farmerEmail'] ?? "N/A"),
                    const Divider(height: 40),
                    
                    if (medications.isNotEmpty) ...[
                      const Text("MEDICATIONS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 12),
                      ...medications.map((m) => _itemRow(m['content'] ?? "Medication", "Prescribed")),
                      const SizedBox(height: 24),
                    ],

                    const Text("CHARGES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 12),
                    ...charges.map((c) {
                      final raw = c['content']?.toString() ?? '0';
                      return _itemRow("Consultation Fee", raw);
                    }),
                    
                    const Divider(height: 40, thickness: 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TOTAL AMOUNT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${totalCharge.toStringAsFixed(2)}", 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Text("Thank you for using Animal Service Platform!", 
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Close"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _itemRow(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
