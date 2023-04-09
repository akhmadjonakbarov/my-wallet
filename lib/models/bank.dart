// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Bank {
  String id;
  double bank;
  DateTime dateTime;
  Bank({
    required this.id,
    required this.bank,
    required this.dateTime,
  });

  Bank copyWith({
    String? id,
    double? bank,
    DateTime? dateTime,
  }) {
    return Bank(
      id: id ?? this.id,
      bank: bank ?? this.bank,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bank': bank,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      id: map['id'] as String,
      bank: map['bank'] as double,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bank.fromJson(String source) =>
      Bank.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Bank(id: $id, bank: $bank, dateTime: $dateTime)';

  @override
  bool operator ==(covariant Bank other) {
    if (identical(this, other)) return true;

    return other.id == id && other.bank == bank && other.dateTime == dateTime;
  }

  @override
  int get hashCode => id.hashCode ^ bank.hashCode ^ dateTime.hashCode;
}
