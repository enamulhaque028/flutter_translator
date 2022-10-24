import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/config/route.dart';
import 'package:translator_app/domain/dropdown_data.dart';
import 'package:translator_app/pdf_to_voice.dart';
import 'package:translator_app/widgets/custom_icon_button.dart';
import 'package:translator_app/widgets/custom_languale_dropdown.dart';
import 'package:translator_app/widgets/custom_text_filed.dart';
import 'package:translator_app/widgets/image_picker_tile.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  TextEditingController inputTextController = TextEditingController();
  TextEditingController outputTextController = TextEditingController();
  final translator = GoogleTranslator();
  bool hasFinished = false;
  FlutterTts flutterTts = FlutterTts();
  //::::::::::::::: TTS :::::::::::::::
  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  //::::::::::::::: STT :::::::::::::::
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  final TextRecognizer textRecognizer = TextRecognizer();
  String inputLanguageCode = 'auto';
  String outputLanguageCode = 'bn';
  

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CustomTextField(
                    textEditingController: inputTextController,
                    placeholderText: 'Enter text here',
                  ),
                  Positioned(
                    right: 20,
                    bottom: 25,
                    child: Row(
                      children: [
                        PickImages(
                          onSelectImage: convertSpeechToText,
                        ),
                        const SizedBox(width: 8),
                        CustomIconButton(
                          onTap: () {
                            _speechToText.isNotListening ? _startListening() : _stopListening();
                          },
                          iconData: _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomLanguageDropdown(
                    hintText: 'Auto',
                    onTapItem: (Language? data) {
                      inputLanguageCode = data!.languageCode;
                    },
                  ),
                  const Icon(Icons.keyboard_double_arrow_right_rounded),
                  CustomLanguageDropdown(
                    hintText: 'Select',
                    onTapItem: translateLanguage,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  CustomTextField(
                    textEditingController: outputTextController,
                    placeholderText: 'Translation',
                  ),
                  hasFinished ? Positioned(
                    right: 20,
                    bottom: 25,
                    child: Row(
                      children: [
                        CustomIconButton(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: outputTextController.text));
                            RouteController.instance.showSnackBar(
                              message: 'Copied to clipboard',
                              milliseconds: 700,
                            );
                          },
                          iconData: Icons.copy,
                        ),
                        const SizedBox(width: 8),
                        CustomIconButton(
                          onTap: () {},
                          iconData: Icons.share,
                        ),
                        const SizedBox(width: 8),
                        CustomIconButton(
                          onTap: convertTextToSpeech,
                          iconData: Icons.volume_up,
                        ),
                      ],
                    ),
                  ) : const SizedBox.shrink(),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Volume')),
                  Slider(
                    min: 0.0,
                    max: 1.0,
                    value: volume,
                    onChanged: (value) {
                      setState(() {
                        volume = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(double.parse(volume.toStringAsFixed(2)).toString()),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Pitch')),
                  Slider(
                    min: 0.5,
                    max: 2.0,
                    value: pitch,
                    onChanged: (value) {
                      setState(() {
                        pitch = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(double.parse(pitch.toStringAsFixed(2)).toString()),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 80, child: Text('Speech Rate')),
                  Slider(
                    min: 0.0,
                    max: 1.0,
                    value: speechRate,
                    onChanged: (value) {
                      setState(() {
                        speechRate = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(double.parse(speechRate.toStringAsFixed(2)).toString()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.picture_as_pdf_sharp),
        onPressed: () {
          RouteController.instance.push(page: const PdfToVoice());
        },
      ),
    );
  }

 //::::::::::::::::::::::::::::: Translate Language :::::::::::::::::::::::::::::
  Future<void> translateLanguage(Language? data) async {
    log(data!.languageCode);
    outputLanguageCode = data.languageCode;
    await flutterTts.stop();
    setState(() {
      outputTextController.text = 'Translating.......';
    });
    Translation translation = await translator.translate(inputTextController.text, to: outputLanguageCode);
    setState(() {
      outputTextController.text = translation.text;
      hasFinished = true;
    });
  }

  //::::::::::::::::::::::::::::: Initialize TTF Settings :::::::::::::::::::::::::::::
  Future<void> initTTSSettings() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
  }

  //::::::::::::::::::::::::::::: Convert Text To Speech :::::::::::::::::::::::::::::
  Future<void> convertTextToSpeech() async {
    // bool isLanguageAvailable = await flutterTts.isLanguageAvailable(languageCode) as bool;
    // if (isLanguageAvailable) {
    //   await flutterTts.speak(outputTextController.text);
    // } else {
    //   String errText = 'Sorry this language is not available!';
    //   await flutterTts.speak(errText);
    //   RouteController.instance.showSnackBar(message: errText);
    initTTSSettings();
    await flutterTts.speak(outputTextController.text);
  }

  //::::::::::::::::::::::::::::: Convert Speech To Text :::::::::::::::::::::::::::::

  // Each time to start a speech recognition session
  void _startListening() async {
    if (inputLanguageCode == 'auto') {
      RouteController.instance.showSnackBar(message: 'please select an input language');
    } else {
      inputTextController.clear();
      outputTextController.clear();
      await _speechToText.listen(onResult: _onSpeechResult, localeId: inputLanguageCode);
      setState(() {});
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      inputTextController.text = result.recognizedWords;
    });
  }


  //::::::::::::::::::::::::::::: Translate Language :::::::::::::::::::::::::::::
  Future<void> convertSpeechToText(imagePath) async {
    inputTextController.clear();
    outputTextController.clear();
    final inputImage = InputImage.fromFilePath(imagePath!);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      // for (TextLine line in block.lines) {
      //   scannedText = '$scannedText${line.text.replaceAll('\n', '')}\n';
      // }
      String blockText = block.text.replaceAll('\n', ' ');
      scannedText = '$scannedText$blockText\n';
    }
    log(scannedText);
    inputTextController.text = scannedText;
    setState(() {});
  }
}