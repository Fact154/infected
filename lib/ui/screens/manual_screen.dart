import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class ManualScreen extends StatefulWidget {
  @override
  _ManualScreenState createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    loadPdfFromAsset();
  }

  Future<void> loadPdfFromAsset() async {
    try {
      // Load PDF from assets
      final ByteData data = await rootBundle.load('assets/Stay_Away_rulebook-web.pdf');
      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final File pdfFile = File('${tempDir.path}/manual.pdf');

      // Write to temporary file
      await pdfFile.writeAsBytes(data.buffer.asUint8List(), mode: FileMode.write);

      setState(() {
        pdfPath = pdfFile.path;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Инструкция")),
      body: pdfPath != null
          ? PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        onRender: (_pages) {
          print('PDF rendered with $_pages pages');
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // You can control PDFViewController here (e.g., jump to page)
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}