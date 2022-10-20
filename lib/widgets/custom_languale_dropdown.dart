// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:translator_app/config/constants.dart';
import 'package:translator_app/config/presentation/app_color.dart';
import 'package:translator_app/domain/dropdown_data.dart';

class CustomLanguageDropdown extends StatefulWidget {
  const CustomLanguageDropdown({
    Key? key,
    required this.hintText,
    required this.onTapItem,
  }) : super(key: key);

  final String hintText;
  final Function(Language) onTapItem;

  @override
  State<CustomLanguageDropdown> createState() => _CustomLanguageDropdownState();
}

class _CustomLanguageDropdownState extends State<CustomLanguageDropdown> {
  List<Language> languageList = [];

  @override
  void initState() {
    String res = json.encode(Constants.allLanguageList);
    languageList = languageFromJson(res);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 55,
      child: DropdownSearch<Language>(
        hint: widget.hintText,
        showSearchBox: true,
        itemAsString: (Language? data) => '${data!.languageName} (${data.nativeName})',
        onChanged: widget.onTapItem,
        items: languageList,
        dropdownSearchDecoration: const InputDecoration(
          fillColor: AppColor.kBackgroundColor,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: AppColor.kBackgroundColor),
          ),
          filled: true,
          contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        ),
      ),
    );
  }
}