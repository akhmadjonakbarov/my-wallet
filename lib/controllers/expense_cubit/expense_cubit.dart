import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../db/expense_operation.dart';
import '../../models/models.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial()) {
    List<Expense> expenses = [];
    ExpenseOperation.getData().then((value) {
      if (value.isEmpty) {
        emit(ExpenseWelcome());
      } else {
        expenses = value;
        emit(ExpenseLoaded(expenses: expenses));
      }
    });
  }

  void add({
    required String title,
    required double price,
    required double amount,
    IconData? iconData,
    required DateTime dateTime,
  }) {
    List<Expense> expenses = [];
    if (state.expenses == null || state.expenses!.isEmpty) {
      expenses = [];
    } else {
      expenses = state.expenses!;
    }
    try {
      emit(ExpenseWelcome());
      Expense expense = Expense(
        id: UniqueKey().toString(),
        title: title,
        amount: amount,
        price: price,
        iconData:
            iconData != null ? iconData.codePoint : Icons.ac_unit.codePoint,
        dateTime: dateTime,
      );
      expenses.insert(0, expense);
      emit(ExpenseLoaded(expenses: expenses));
      ExpenseOperation.insertData(data: expense.toMap());
    } catch (e) {
      emit(
        ExpenseError(errorMsg: e.toString()),
      );
    }
  }

  void update({required Expense expense}) {
    try {
      List<Expense> expenses = state.expenses!.map((e) {
        if (e.id == expense.id) {
          return Expense(
            id: expense.id,
            title: expense.title,
            amount: expense.amount,
            price: expense.price,
            iconData: expense.iconData,
            dateTime: expense.dateTime,
          );
        }
        return e;
      }).toList();
    } catch (e) {
      emit(
        ExpenseError(errorMsg: e.toString()),
      );
    }
  }

  void delete({required Expense expense}) {
    List<Expense> expenses = state.expenses!;
    try {
      expenses.removeWhere((element) => element.id == expense.id);
      emit(ExpenseLoading());
      emit(ExpenseLoaded(expenses: expenses));
      ExpenseOperation.deleteData(expense: expense);
    } catch (e) {
      emit(
        ExpenseError(errorMsg: e.toString()),
      );
    }
  }

  List<Expense> searchExpense({String? title}) {
    return state.expenses!
        .where(
          (element) => element.title.toLowerCase().contains(
                title!.toLowerCase(),
              ),
        )
        .toList();
  }

  void filterByMonth({required DateTime dateTime}) {
    List<Expense> expenses = state.expenses ?? [];
    List<Expense> filteredExpense = [];
    if (expenses.isNotEmpty) {
      for (var element in expenses) {
        if (element.dateTime.month == dateTime.month &&
            element.dateTime.year == dateTime.year) {
          filteredExpense.add(element);
        }
      }
      emit(ExpenseLoaded(expenses: filteredExpense));
    } else {
      emit(ExpenseWelcome());
    }
  }
}
