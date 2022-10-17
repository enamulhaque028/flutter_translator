import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/domain/dropdown_data.dart';
import 'package:translator_app/widgets/custom_text_filed.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  TextEditingController inputTextController = TextEditingController();
  TextEditingController outputTextController = TextEditingController();
  final translator = GoogleTranslator();
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
              DropdownSearch<DefaultDropdown>(
                hint: 'Select language to translate',
                showSearchBox: true,
                itemAsString: (DefaultDropdown? data) => data!.language,
                onChanged: (DefaultDropdown? data) async {
                  log(data!.languageCode);
                  setState(() {
                    outputTextController.text = 'Translating.......';
                  });
                  Translation translation = await translator.translate(inputTextController.text, to: data.languageCode);
                  setState(() {
                    outputTextController.text = translation.text;
                  });
                },
                items: kLanguageList,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                textEditingController: outputTextController,
                placeholderText: 'Translation',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
