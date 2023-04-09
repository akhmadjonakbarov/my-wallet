import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../db/expense_operation.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial()) {
    ExpenseOperation.getData().then((data) {
      if (data.isEmpty) {
        emit(ExpenseWelcome());
      } else {
        filterByMonth(
          dateTime: DateTime.now(),
        );
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
    List<Expense> expenses = state.expenses ?? [];
    try {
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
          ExpenseOperation.updateData(expense: expense);
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
    List<Expense> expenses = state.expenses ?? [];
    try {
      emit(ExpenseLoading());
      expenses.isNotEmpty
          ? expenses.removeWhere((element) => element.id == expense.id)
          : null;
      if (expenses.length != 0) {
        emit(
          ExpenseLoaded(
            expenses: expenses,
          ),
        );
      } else {
        emit(ExpenseWelcome());
      }
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

  Future<double> totalExpenseByMonth({required DateTime dateTime}) async {
    List<Expense> expenses = [];
    List<Expense> filteredExpenses = [];
    double totalSum = 0.0;
    expenses = await ExpenseOperation.getData();
    filteredExpenses = expenses.isNotEmpty
        ? expenses
            .where(
              (element) =>
                  element.dateTime.month == dateTime.month &&
                  element.dateTime.year == dateTime.year,
            )
            .toList()
        : [];
    for (var element in filteredExpenses) {
      totalSum = totalSum + element.price;
    }
    return totalSum;
  }

  Future<void> filterByMonth({required DateTime dateTime}) async {
    List<Expense> expenses = [];
    List<Expense> filteredExpenses = [];
    emit(ExpenseInitial());
    try {
      expenses = await ExpenseOperation.getData();

      filteredExpenses = expenses.isNotEmpty
          ? expenses
              .where(
                (element) =>
                    element.dateTime.month == dateTime.month &&
                    element.dateTime.year == dateTime.year,
              )
              .toList()
          : [];
      filteredExpenses.isNotEmpty
          ? emit(ExpenseLoaded(expenses: filteredExpenses))
          : emit(ExpenseWelcome());
    } catch (e) {
      emit(
        ExpenseError(errorMsg: e.toString()),
      );
    }
  }
}
