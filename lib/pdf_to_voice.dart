import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator_app/widgets/custom_button.dart';

class PdfToVoice extends StatefulWidget {
  const PdfToVoice({super.key});

  @override
  State<PdfToVoice> createState() => _PdfToVoiceState();
}

class _PdfToVoiceState extends State<PdfToVoice> {
  FlutterTts flutterTts = FlutterTts();
  String selectedTextFromPdf = 'please  select text for listening';
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;
  
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF to Voice'),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        'https://files.peacecorps.gov/multimedia/audio/languagelessons/thailand/TH_Thai_Language_Lessons.pdf',
        controller: _pdfViewerController,
        enableTextSelection: true,
        onTextSelectionChanged: onSelectText,
        onPageChanged: (details) {
          log(details.newPageNumber.toString());
        },
      ),
    );
  }

  void onSelectText(PdfTextSelectionChangedDetails details) {
    if (details.selectedText == null && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else if (details.selectedText != null && _overlayEntry == null) {
      String text = details.selectedText!;
      setState(() {
        selectedTextFromPdf = text;
      });
      log(text);
      _showContextMenu(context, details);
    }
  }
  
  //::::::::::::::::::::::::::::: Convert Text To Speech :::::::::::::::::::::::::::::
  Future<void> convertTextToSpeech() async {
    await flutterTts.speak(selectedTextFromPdf);
  }

  //::::::::::::::::::::::::::::: Stop Speech :::::::::::::::::::::::::::::
  Future<void> stoSpeech() async {
    await flutterTts.stop();
    _pdfViewerController.clearSelection();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                child: const Text('Copy', style: TextStyle(fontSize: 17)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: details.selectedText));
                  log('Text copied to clipboard: ${details.selectedText}');
                  _pdfViewerController.clearSelection();
                },
              ),
              CustomButton(
                onTap: convertTextToSpeech,
                child: const Icon(Icons.volume_up),
              ),
              CustomButton(
                onTap: stoSpeech,
                child: const Icon(Icons.stop),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }
}
