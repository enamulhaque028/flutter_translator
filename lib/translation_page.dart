import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  String languageCode = '';

  @override
  void initState() {
    String res = json.encode(Constants.allLanguageList);
    languageList = languageFromJson(res);
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
                onChanged: (Language? data) async {
                  log(data!.languageCode);
                  await flutterTts.stop();
                  setState(() {
                    outputTextController.text = 'Translating.......';
                  });
                  Translation translation = await translator.translate(inputTextController.text, to: data.languageCode);
                  setState(() {
                    outputTextController.text = translation.text;
                    hasFinished = true;
                    languageCode = data.languageCode;
                  });
                },
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
                          onTap: controlTextToSpeech,
                          iconData: Icons.volume_up,
                        ),
                      ],
                    ),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> controlTextToSpeech() async {
    // bool isLanguageAvailable = await flutterTts.isLanguageAvailable(languageCode) as bool;
    // if (isLanguageAvailable) {
    //   await flutterTts.speak(outputTextController.text);
    // } else {
    //   String errText = 'Sorry this language is not available!';
    //   await flutterTts.speak(errText);
    //   RouteController.instance.showSnackBar(message: errText);
    // }
    await flutterTts.speak(outputTextController.text);
  }
}