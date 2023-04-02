// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Expense {
  String id;
  String title;
  double amount;
  double price;
  IconData iconData;
  DateTime dateTime;
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.price,
    required this.iconData,
    required this.dateTime,
  });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    double? price,
    IconData? iconData,
    DateTime? dateTime,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      iconData: iconData ?? this.iconData,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'price': price,
      'iconData': iconData.codePoint,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      price: map['price'] as double,
      iconData: IconData(map['iconData'] as int, fontFamily: 'MaterialIcons'),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, price: $price, iconData: $iconData, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant Expense other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.price == price &&
        other.iconData == iconData &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        price.hashCode ^
        iconData.hashCode ^
        dateTime.hashCode;
  }
}
