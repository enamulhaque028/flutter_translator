import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfToVoice extends StatelessWidget {
  const PdfToVoice({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterTts flutterTts = FlutterTts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF to Voice'),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        'https://www.eajournals.org/wp-content/uploads/OK-BJEL-Transliteration-and-Translation.pdf',
        enableTextSelection: true,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) async {
          if (details.selectedText != null) {
            String text = details.selectedText!;
            log(text);
            await flutterTts.speak(text);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: () {
          flutterTts.stop();
        },
      ),
    );
  }
}
