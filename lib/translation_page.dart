import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/config/route.dart';
import 'package:translator_app/domain/dropdown_data.dart';
import 'package:translator_app/widgets/custom_icon_button.dart';
import 'package:translator_app/widgets/custom_text_filed.dart';

import 'config/constants.dart';

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
  List<Language> languageList = [];
  //::::::::::::::: TTS :::::::::::::::
  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  //::::::::::::::: STT :::::::::::::::
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    String res = json.encode(Constants.allLanguageList);
    languageList = languageFromJson(res);
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                textEditingController: inputTextController,
                placeholderText: 'Enter text here',
              ),
              DropdownSearch<Language>(
                hint: 'Select language to translate',
                showSearchBox: true,
                itemAsString: (Language? data) => '${data!.languageName} (${data.nativeName})',
                onChanged: translateLanguage,
                items: languageList,
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
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        onPressed: () {
          // RouteController.instance.push(page: const VoiceToTextWidget());
          _speechToText.isNotListening ? _startListening() : _stopListening();
        },
      ),
    );
  }

  //::::::::::::::::::::::::::::: Translate Language :::::::::::::::::::::::::::::
  Future<void> translateLanguage(Language? data) async {
    log(data!.languageCode);
    await flutterTts.stop();
    setState(() {
      outputTextController.text = 'Translating.......';
    });
    Translation translation = await translator.translate(inputTextController.text, to: data.languageCode);
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
    inputTextController.clear();
    outputTextController.clear();
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'bn');
    setState(() {});
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
}