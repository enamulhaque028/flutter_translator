class DefaultDropdown {
  String language;
  String languageCode;

  DefaultDropdown({
    required this.language,
    required this.languageCode,
  });
}


///Language Data
List<DefaultDropdown> kLanguageList = [
  DefaultDropdown(
    language: 'English',
    languageCode: 'en',
  ),
  DefaultDropdown(
    language: 'Bengali',
    languageCode: 'bn',
  ),
  DefaultDropdown(
    language: 'Hindi',
    languageCode: 'hi',
  ),
  DefaultDropdown(
    language: 'Urdu',
    languageCode: 'ur',
  ),
];