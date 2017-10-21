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

import 'package:financial_note/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Transaction {
  static const kNodeName = 'transactions';

  String id;
  String billId;
  String budgetId;
  String title;
  DateTime date;
  double value;
  double balance;
  String note;

  Transaction({
    this.id,
    this.billId,
    this.budgetId,
    this.title,
    this.date,
    this.value: 0.0,
    this.balance: 0.0,
    this.note,
  });

  Transaction.fromJson(this.id, Map<String, dynamic> json)
    : billId    = parseString(mapValue(json, 'billId')),
      budgetId  = parseString(mapValue(json, 'budgetId')),
      title     = parseString(mapValue(json, 'title')),
      date      = parseDate(mapValue(json, 'date')),
      value     = parseDouble(mapValue(json, 'value')),
      balance   = parseDouble(mapValue(json, 'balance')),
      note      = parseString(mapValue(json, 'note'));

  static DatabaseReference ref(String bookId) {
    return FirebaseDatabase.instance.reference().child(kNodeName).child(bookId);
  }

  static Future<List<Transaction>> list(
      String bookId, DateTime dateStart, DateTime dateEnd, openingBalance,
  ) async {
    final formatter = new DateFormat('yyyy-MM-dd');
    final ret = new List<Transaction>();

    ret.add(new Transaction(
      title   : 'Opening Balance',
      date    : dateStart,
      value   : openingBalance,
      balance : openingBalance,
    ));

    final snap = await ref(bookId)
        .orderByChild('paidDate')
        .startAt(formatter.format(dateStart), key: 'paidDate')
        .endAt(formatter.format(dateEnd), key: 'paidDate')
        .once();

    if (snap.value == null) return ret;

    var balance = openingBalance;
    final Map<String, Map<String, dynamic>> items = snap.value;
    items.forEach((key, item) {
      balance += parseDouble(mapValue(item, 'value'));
      item['balance'] = balance;
      ret.add(new Transaction.fromJson(key, item));
    });

    return ret;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'billId'   : billId,
      'budgetId' : budgetId,
      'title'    : title,
      'date'     : date?.toIso8601String(),
      'value'    : value,
      'balance'  : balance,
      'note'     : note,
    };
  }

  Transaction copyWith({
    String id,
    String billId,
    String budgetId,
    String title,
    DateTime date,
    double value,
    double balance,
    String note,
  }) {
    return new Transaction(
      id       : id       ?? this.id,
      billId   : billId   ?? this.billId,
      budgetId : budgetId ?? this.budgetId,
      title    : title    ?? this.title,
      date     : date     ?? this.date,
      value    : value    ?? this.value,
      balance  : balance  ?? this.balance,
      note     : note     ?? this.note,
    );
  }
}
