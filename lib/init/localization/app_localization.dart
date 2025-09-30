
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Locales {
  tr(Locale("tr","TR")),
  en(Locale("en","EN"));

  final Locale locale;
  const Locales(this.locale);
}

final class AppLocalization extends EasyLocalization {
  AppLocalization({super.key, required super.child})
    : super(supportedLocales: _supportedLocalItems, path: _translationPath);

  static const String _translationPath = "assets/translations";
  static final List<Locale> _supportedLocalItems = [
    Locales.tr.locale,
    Locales.en.locale,
  ];

  Future<void> changeLanguage(Locales language, BuildContext context) async {
    await context.setLocale(language.locale);
  }
}


