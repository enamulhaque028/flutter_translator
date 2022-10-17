import 'dart:convert';

List<Language> languageFromJson(String str) => List<Language>.from(json.decode(str).map((x) => Language.fromJson(x)));

class Language {
  Language({
    required this.languageCode,
    required this.languageName,
    required this.nativeName,
  });

  final String languageCode;
  final String languageName;
  final String nativeName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    languageCode: json["languageCode"],
    languageName: json["languageName"],
    nativeName: json["nativeName"],
  );

  Map<String, dynamic> toJson() => {
    "languageCode": languageCode,
    "languageName": languageName,
    "nativeName": nativeName,
  };
}



