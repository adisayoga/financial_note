
/*
 * Copyright (c) 2017. All rights reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 *
 * Written by:
 *   - Adi Sayoga <adisayoga@gmail.com>
 */

library page;

import 'dart:async';
import 'dart:convert';

import 'package:financial_note/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

export 'src/page/budget_page.dart';
export 'src/page/home_page.dart';
export 'src/page/settings_page.dart';
export 'src/page/sign_in_page.dart';
export 'src/page/splash_page.dart';
export 'src/page/transaction_page.dart';

const kBgActionMode = Colors.black54;

const kIconHome = const Icon(Icons.home);
const kIconBill = const Icon(Icons.monetization_on);
const kIconBudget = const Icon(Icons.insert_chart);

const kIconBack = const Icon(Icons.arrow_back);
const kIconClose = const Icon(Icons.close);
const kIconAdd = const Icon(Icons.add);
const kIconSearch = const Icon(Icons.search);
const kIconEdit = const Icon(Icons.edit);
const kIconDelete = const Icon(Icons.delete);

typedef void OnItemTap<T>(T item);
typedef void OnItemSelect<T>(List<T> items, int index);
typedef void OnActionTap<T>(String key, T items);

Widget buildListProgress(Listenable animation, {isLoading: false}) {
  return new AnimatedBuilder(animation: animation, builder: (context, child) {
    if (!isLoading) return new Container();
    return const SizedBox(height: 2.0, child: const LinearProgressIndicator());
  });
}

/// Push named navigator dengan params.
String routeWithParams(String routeName, Map<String, dynamic> params) {
  if (params != null) routeName += '?' + JSON.encode(params);
  return routeName;
}

/// Get route name dan parameter dari route RouteSettings
/// return array Index 0 -> route name, Index 1 -> params
List<dynamic> getRouteParams(RouteSettings settings) {
  if (settings.name == null) return [null, null];

  final routes = settings.name.split('?');
  return [
    routes[0],
    routes.length > 1 ? JSON.decode(routes[1]) : null,
  ];
}

Future<bool> showConfirmDialog(BuildContext context, Widget content, {Widget title}) {
  final lang = Lang.of(context);
  return showDialog<bool>(
    context: context,
    child: new AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.pop(context, false),
          child: new Text(lang.btnNo().toUpperCase()),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context, true),
          child: new Text(lang.btnYes().toUpperCase()),
        ),
      ],
    ),
  );
}
