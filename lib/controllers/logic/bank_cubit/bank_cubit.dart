// ignore_for_file: unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_wallet/controllers/db/bank_operation.dart';
import 'package:my_wallet/models/models.dart';

part 'bank_state.dart';

class BankCubit extends Cubit<BankState> {
  BankCubit() : super(BankInitial()) {
    BankOperation.getData().then((value) {
      if (value.isEmpty) {
        emit(BankWelcome());
      } else {
        filterByMonth(
          dateTime: DateTime.now(),
        );
      }
    });
  }

  void add({required double value, required DateTime dateTime}) {
    List<Bank> banks = state.banks ?? [];
    try {
      Bank bank = Bank(
        id: UniqueKey().toString(),
        bank: value,
        dateTime: dateTime,
      );
      banks.insert(0, bank);
      emit(BankLoaded(banks: banks));
      BankOperation.insertData(
        data: bank.toMap(),
      );
    } catch (e) {
      emit(
        BankError(
          errorMsg: e.toString(),
        ),
      );
    }
  }

  void update({required Bank bank}) {
    try {
      List<Bank> banks = state.banks!.map((e) {
        if (e.id == bank.id) {
          BankOperation.updateData(bank: bank);
          return Bank(id: bank.id, bank: bank.bank, dateTime: bank.dateTime);
        }
        return e;
      }).toList();
    } catch (e) {
      emit(
        BankError(errorMsg: e.toString()),
      );
    }
  }

  Future<Bank> getLastBank({required DateTime dateTime}) async {
    List<dynamic> banks = [];
    List<dynamic> filteredBank = [];
    Bank bank = Bank(
      id: UniqueKey().toString(),
      bank: 250000,
      dateTime: DateTime.now(),
    );

    banks = await BankOperation.getData();
    filteredBank = banks.isNotEmpty
        ? banks
            .where(
              (element) =>
                  element.dateTime.month == dateTime.month &&
                  element.dateTime.year == dateTime.year,
            )
            .toList()
        : [];

    if (filteredBank.isEmpty) {
      filteredBank.insert(0, bank);
      bank = filteredBank.first;
    } else {
      bank = filteredBank.first;
    }
    return bank;
  }

  Future<void> filterByMonth({required DateTime dateTime}) async {
    List<Bank> banks = [];
    List<Bank> filteredBanks = [];
    emit(BankInitial());
    try {
      banks = await BankOperation.getData();

      filteredBanks = banks.isNotEmpty
          ? banks
              .where(
                (element) =>
                    element.dateTime.month == dateTime.month &&
                    element.dateTime.year == dateTime.year,
              )
              .toList()
          : [];
      filteredBanks.isNotEmpty
          ? emit(BankLoaded(banks: filteredBanks))
          : emit(BankWelcome());
    } catch (e) {
      emit(
        BankError(
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
