import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  PDFViewerScreen({required this.pdfUrl});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    downloadAndSavePDF();
  }

  Future<void> downloadAndSavePDF() async {
    try {
      var response = await http.get(Uri.parse(widget.pdfUrl));
      var documentDirectory = await getApplicationDocumentsDirectory();
      File file = File("${documentDirectory.path}/temp.pdf");
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        localFilePath = file.path;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to load PDF", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View PDF")),
      body: localFilePath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: localFilePath!,
      ),
    );
  }
}
