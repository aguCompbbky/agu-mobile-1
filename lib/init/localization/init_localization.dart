import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class InitLocalization{
  
  static Future<void> startInitilazition() async {
    await runZonedGuarded(_initilaze, (error,stack){});
  }

  static Future<void> _initilaze() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  }
}