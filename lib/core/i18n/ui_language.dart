import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class UiLanguage {
  final String code;
  final String Function(AppLocalizations l10n) labelBuilder;

  const UiLanguage(this.code, this.labelBuilder);
}

const List<UiLanguage> kSupportedUiLanguages = [
  UiLanguage('en', _english),
  UiLanguage('es', _spanish),
  UiLanguage('fr', _french),
  UiLanguage('de', _german),
  UiLanguage('it', _italian),
  UiLanguage('pt', _portuguese),
  UiLanguage('ru', _russian),
  UiLanguage('ja', _japanese),
  UiLanguage('zh', _chinese),
  UiLanguage('ar', _arabic),
  UiLanguage('hi', _hindi),
  UiLanguage('id', _indonesian),
  UiLanguage('bn', _bengali),
  UiLanguage('ur', _urdu),
  UiLanguage('vi', _vietnamese),
  UiLanguage('tr', _turkish),
  UiLanguage('ko', _korean),
  UiLanguage('th', _thai),
  UiLanguage('pl', _polish),
  UiLanguage('uk', _ukrainian),
  UiLanguage('nl', _dutch),
  UiLanguage('fa', _persian),
  UiLanguage('pa', _punjabi),
  UiLanguage('ta', _tamil),
  UiLanguage('te', _telugu),
  UiLanguage('sw', _swahili),
  UiLanguage('ms', _malay),
  UiLanguage('ro', _romanian),
  UiLanguage('el', _greek),
  UiLanguage('hu', _hungarian),
  UiLanguage('cs', _czech),
  UiLanguage('sv', _swedish),
  UiLanguage('he', _hebrew),
  UiLanguage('no', _norwegian),
  UiLanguage('da', _danish),
  UiLanguage('fi', _finnish),
];

const Map<String, String> _legacyNameToCode = {
  'English': 'en',
  'Spanish': 'es',
  'French': 'fr',
  'German': 'de',
  'Italian': 'it',
  'Portuguese': 'pt',
  'Russian': 'ru',
  'Japanese': 'ja',
  'Chinese': 'zh',
  'Arabic': 'ar',
  'Hindi': 'hi',
  'Indonesian': 'id',
  'Bengali': 'bn',
  'Urdu': 'ur',
  'Vietnamese': 'vi',
  'Turkish': 'tr',
  'Korean': 'ko',
  'Thai': 'th',
  'Polish': 'pl',
  'Ukrainian': 'uk',
  'Dutch': 'nl',
  'Persian': 'fa',
  'Punjabi': 'pa',
  'Tamil': 'ta',
  'Telugu': 'te',
  'Swahili': 'sw',
  'Malay': 'ms',
  'Romanian': 'ro',
  'Greek': 'el',
  'Hungarian': 'hu',
  'Czech': 'cs',
  'Swedish': 'sv',
  'Hebrew': 'he',
  'Norwegian': 'no',
  'Danish': 'da',
  'Finnish': 'fi',
};

String normalizeUiLanguageCode(final String? rawValue) {
  final value = (rawValue ?? '').trim();
  if (value.isEmpty) return 'en';
  if (kSupportedUiLanguages.any((final language) => language.code == value)) {
    return value;
  }
  return _legacyNameToCode[value] ?? 'en';
}

Locale uiLanguageToLocale(final String? rawValue) {
  return Locale(normalizeUiLanguageCode(rawValue));
}

String uiLanguageLabel(final String rawValue, final AppLocalizations l10n) {
  final code = normalizeUiLanguageCode(rawValue);
  final language = kSupportedUiLanguages.firstWhere(
    (final item) => item.code == code,
    orElse: () => kSupportedUiLanguages.first,
  );
  return language.labelBuilder(l10n);
}

String _english(final AppLocalizations l10n) => l10n.languageEnglish;
String _spanish(final AppLocalizations l10n) => l10n.languageSpanish;
String _french(final AppLocalizations l10n) => l10n.languageFrench;
String _german(final AppLocalizations l10n) => l10n.languageGerman;
String _italian(final AppLocalizations l10n) => l10n.languageItalian;
String _portuguese(final AppLocalizations l10n) => l10n.languagePortuguese;
String _russian(final AppLocalizations l10n) => l10n.languageRussian;
String _japanese(final AppLocalizations l10n) => l10n.languageJapanese;
String _chinese(final AppLocalizations l10n) => l10n.languageChinese;
String _arabic(final AppLocalizations l10n) => l10n.languageArabic;
String _hindi(final AppLocalizations l10n) => l10n.languageHindi;
String _indonesian(final AppLocalizations l10n) => l10n.languageIndonesian;
String _bengali(final AppLocalizations l10n) => l10n.languageBengali;
String _urdu(final AppLocalizations l10n) => l10n.languageUrdu;
String _vietnamese(final AppLocalizations l10n) => l10n.languageVietnamese;
String _turkish(final AppLocalizations l10n) => l10n.languageTurkish;
String _korean(final AppLocalizations l10n) => l10n.languageKorean;
String _thai(final AppLocalizations l10n) => l10n.languageThai;
String _polish(final AppLocalizations l10n) => l10n.languagePolish;
String _ukrainian(final AppLocalizations l10n) => l10n.languageUkrainian;
String _dutch(final AppLocalizations l10n) => l10n.languageDutch;
String _persian(final AppLocalizations l10n) => l10n.languagePersian;
String _punjabi(final AppLocalizations l10n) => l10n.languagePunjabi;
String _tamil(final AppLocalizations l10n) => l10n.languageTamil;
String _telugu(final AppLocalizations l10n) => l10n.languageTelugu;
String _swahili(final AppLocalizations l10n) => l10n.languageSwahili;
String _malay(final AppLocalizations l10n) => l10n.languageMalay;
String _romanian(final AppLocalizations l10n) => l10n.languageRomanian;
String _greek(final AppLocalizations l10n) => l10n.languageGreek;
String _hungarian(final AppLocalizations l10n) => l10n.languageHungarian;
String _czech(final AppLocalizations l10n) => l10n.languageCzech;
String _swedish(final AppLocalizations l10n) => l10n.languageSwedish;
String _hebrew(final AppLocalizations l10n) => l10n.languageHebrew;
String _norwegian(final AppLocalizations l10n) => l10n.languageNorwegian;
String _danish(final AppLocalizations l10n) => l10n.languageDanish;
String _finnish(final AppLocalizations l10n) => l10n.languageFinnish;
