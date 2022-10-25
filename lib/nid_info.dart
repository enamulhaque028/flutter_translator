import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator_app/widgets/image_picker_tile.dart';

class NidInfo extends StatefulWidget {
  const NidInfo({super.key});

  @override
  State<NidInfo> createState() => _NidInfoState();
}

class _NidInfoState extends State<NidInfo> {
  final TextRecognizer textRecognizer = TextRecognizer();
  String name = '';
  String nidNo = '';
  String dateOfBirth = '';
  String ocrText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NID Info'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PickImages(
              onSelectImage: scanTextFromNid,
            ),
            const SizedBox(height: 16),
            Text('Name: $name'),
            Text('NID No: $nidNo'),
            Text('Date of Birth: $dateOfBirth'),
          ],
        ),
      ),
    );
  }

  Future<void> scanTextFromNid(imagePath) async {
    setState(() {
      name = '';
      nidNo = '';
      dateOfBirth = '';
      ocrText = '';
    });
    final inputImage = InputImage.fromFilePath(imagePath!);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        ocrText += '${line.text}@';
      }
    }
    log(ocrText);
    setState(() {
      name = getText('name@', '@');
      nidNo = getText('nid no@', '@');
      dateOfBirth = getText('@date of birth', '@').trimLeft();
    });
  }

  String getText(String start, String end) {
    String textFromOcr = 'not found! Invalid NID!!!';
    String str = ocrText.toLowerCase();
    final startIndex = str.indexOf(start);
    if (startIndex != -1) {
      final endIndex = str.indexOf(end, startIndex + start.length);
      textFromOcr = str.substring(startIndex + start.length, endIndex);
    }
    return textFromOcr.toUpperCase();
  }
}