import 'dart:io';

import 'package:college_project/views/screens/pdf_view_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/colors.dart';

class PaymentStatusShowScreen extends StatefulWidget {
  const PaymentStatusShowScreen({super.key});

  @override
  _PaymentStatusShowScreenState createState() =>
      _PaymentStatusShowScreenState();
}

class _PaymentStatusShowScreenState extends State<PaymentStatusShowScreen> {
  String? _selectedStream;
  String? _selectedSemester;
  bool _isLoading = false;
  List<Map<String, dynamic>> _paidStudents = [];
  List<Map<String, dynamic>> _unpaidStudents = [];

  final Map<String, List<String>> _streamSemesterMap = {
    'BCA': [
      'All',
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8'
    ],
    'BCOM': [
      'All',
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8'
    ],
    'BBA': [
      'All',
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8'
    ],
  };

  List<String> _filteredSemesters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Status',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Stream Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Stream',
                labelStyle:
                    TextStyle(color: AppColor.primaryColor), // Label color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AppColor.primaryColor, width: 2), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColor.primaryColor,
                      width: 2), // Focused border color
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedStream,
              items: _streamSemesterMap.keys.map((String stream) {
                return DropdownMenuItem<String>(
                  value: stream,
                  child: Text(stream,
                      style: TextStyle(
                          color: AppColor.primaryColor)), // Text color
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStream = newValue;
                  _filteredSemesters = _streamSemesterMap[newValue!] ?? [];
                  _selectedSemester = null;
                  _paidStudents.clear();
                  _unpaidStudents.clear();
                });
              },
            ),
            const SizedBox(height: 20),

            /// Semester Dropdown with "All" Option
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Semester',
                labelStyle:
                    TextStyle(color: AppColor.primaryColor), // Label color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AppColor.primaryColor, width: 2), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColor.primaryColor,
                      width: 2), // Focused border color
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _selectedSemester,
              items: _filteredSemesters.map((String semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester,
                      style: TextStyle(
                          color: AppColor.primaryColor)), // Text color
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSemester = newValue;
                  _paidStudents.clear();
                  _unpaidStudents.clear();
                });
              },
            ),
            const SizedBox(height: 20),

            /// Check Payment Status Button
            ElevatedButton(
              onPressed: _isLoading ? null : _checkPaymentStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Check Payment Status',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),

            /// Display Paid and Unpaid Students
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        if (_paidStudents.isEmpty && _unpaidStudents.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'No students found',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            ),
                          ),
                        if (_paidStudents.isNotEmpty)
                          _buildSection(
                              'Paid Students', _paidStudents, Colors.green),
                        if (_unpaidStudents.isNotEmpty)
                          _buildSection(
                              'Unpaid Students', _unpaidStudents, Colors.red),
                      ],
                    ),
            ),

            /// ✅ Report Button at the Bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton(
                onPressed: _generatePDFReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to check payment status
  Future<void> _checkPaymentStatus() async {
    if (_selectedStream == null || _selectedSemester == null) {
      Get.snackbar(
        'Error',
        'Please select both stream and semester.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _paidStudents.clear();
      _unpaidStudents.clear();
    });

    try {
      // Fetch Paid Students
      DatabaseReference paymentsRef =
          FirebaseDatabase.instance.ref().child('paymentsComplete');
      final paymentsEvent = await paymentsRef.once();

      if (paymentsEvent.snapshot.value != null &&
          paymentsEvent.snapshot.value is Map) {
        final paymentsData =
            Map<String, dynamic>.from(paymentsEvent.snapshot.value as Map);

        paymentsData.forEach((key, value) {
          final payment = Map<String, dynamic>.from(value ?? {});

          if ((payment['stream'] ?? '') == _selectedStream &&
              (payment['status'] ?? '') == 'Paid') {
            _paidStudents.add({
              'name': payment['studentName'] ?? 'Unknown',
              'spid': payment['spid'] ?? 'N/A',
              'status': 'Paid'
            });
          }
        });
      }

      // Fetch Unpaid Students
      DatabaseReference studentsRef =
          FirebaseDatabase.instance.ref().child('student');
      final studentsEvent = await studentsRef.once();

      if (studentsEvent.snapshot.value != null &&
          studentsEvent.snapshot.value is Map) {
        final studentsData =
            Map<String, dynamic>.from(studentsEvent.snapshot.value as Map);

        studentsData.forEach((key, value) {
          final student = Map<String, dynamic>.from(value ?? {});

          if ((student['stream'] ?? '') == _selectedStream &&
              (_selectedSemester == 'All' ||
                  student['semester'] == _selectedSemester) &&
              (student['status'] ?? '') == 'unpaid') {
            _unpaidStudents.add({
              'name':
                  '${student['firstName'] ?? ''} ${student['lastName'] ?? ''}',
              'spid': student['spid'] ?? 'N/A',
              'status': 'Unpaid'
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching payment status: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Function to build student sections
  Widget _buildSection(
      String title, List<Map<String, dynamic>> students, Color color) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: students
            .map((student) => ListTile(
                  title: Text(student['name']),
                  subtitle: Text('SPID: ${student['spid']}'),
                  trailing: Text(
                    student['status'],
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
      ),
    );
  }

  /// Function to generate, save, and open PDF report
  Future<void> _generatePDFReport() async {
    final pdf = pw.Document();

    // Add college logo and name
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/splash_icon/app_Logo.png'))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 50, height: 50),
                  pw.Text(
                    'Your College Name',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Payment Status Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (_paidStudents.isNotEmpty) ...[
                pw.Text(
                  'Paid Students:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                _buildTable(_paidStudents),
                pw.SizedBox(height: 10),
              ],
              if (_unpaidStudents.isNotEmpty) ...[
                pw.Text(
                  'Unpaid Students:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                _buildTable(_unpaidStudents),
              ],
            ],
          );
        },
      ),
    );

    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      try {
        final directory = Directory('/storage/emulated/0/Download');
        final file = File('${directory.path}/payment_status_report.pdf');
        await file.writeAsBytes(await pdf.save());

        Get.snackbar(
          'Success',
          'PDF report saved to Downloads folder.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Open the PDF using flutter_pdfview
        Get.to(() => PDFViewScreen(filePath: file.path));
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save or open PDF.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to save the PDF.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  /// Function to build a table for the PDF
  pw.Widget _buildTable(List<Map<String, dynamic>> students) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Name',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('SPID',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text('Last Updated',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...students.map(
          (student) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(student['name']),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(student['spid']),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(student['status']),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(student['lastUpdated'] ?? 'N/A'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
