import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/controllers/db/expense_operation.dart';
import 'package:my_wallet/models/models.dart';

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
    required IconData iconData,
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
        iconData: iconData,
        dateTime: dateTime,
      );
      expenses.add(expense);
      emit(ExpenseLoaded(expenses: expenses));
      ExpenseOperation.insertData(data: expense.toMap());
    } catch (e) {
      emit(ExpenseError(errorMsg: e.toString()));
    }
  }

  void update({required Expense expense}) {
    try {
      List<Expense> expense = state.expenses!.map((e) {
        return e;
      }).toList();
    } catch (e) {
      emit(ExpenseError(errorMsg: e.toString()));
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
}
