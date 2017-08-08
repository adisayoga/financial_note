/*
 * Copyright (c) 2017. All rights reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 *
 * Written by:
 *   - Adi Sayoga <adisayoga@gmail.com>
 */

import 'dart:async';

import 'package:financial_note/config.dart';
import 'package:financial_note/page.dart';
import 'package:financial_note/src/i18n/lang_messages_all.dart';
import 'package:financial_note/strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kTitle = 'Financial Note';

Future<Null> main() async {
  final prefs = await SharedPreferences.getInstance();
  final config = new Config.fromPrefs(prefs);
  runApp(new MainApp(config));
}

class MainApp extends StatefulWidget {
  final Config _config;

  const MainApp(this._config);

  @override
  _MainAppState createState() => new _MainAppState(_config);
}

class _MainAppState extends State<MainApp> {
  Config _config;

  _MainAppState(this._config);

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10 * 1000 * 1000);
  }

  Route<Null> _getRoute(RouteSettings settings) {
    return new MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case HomePage.kRouteName:
            return new HomePage(_config);
          case SignInPage.kRouteName:
            return new SignInPage(_config);
          case SettingsPage.kRouteName:
            return new SettingsPage(_config, _configUpdater);
          case TransactionPage.kRouteName:
            return new TransactionPage(_config);
          default:
            return new SplashPage(_config);
        }
      }
    );
  }

  void _configUpdater(Config value) {
    setState(() => _config = value);
  }

  Future<LocaleQueryData> _onLocaleChanged(Locale locale) async {
    final localeString = locale.toString();
    await initializeMessages(localeString);
    Intl.defaultLocale = localeString;
    return Lang.instance;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: kTitle,
      theme: _config.themeData,
      onGenerateRoute: _getRoute,
      onLocaleChanged: _onLocaleChanged,
    );
  }
}
