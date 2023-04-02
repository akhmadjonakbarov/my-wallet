part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState({this.expenses});
  final List<Expense>? expenses;

  @override
  List<Object> get props => [
        expenses!,
      ];
}

class ExpenseWelcome extends ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  List<Expense> expenses;
  ExpenseLoaded({required this.expenses});
}

class ExpenseDelete extends ExpenseState {}

class ExpenseError extends ExpenseState {
  String errorMsg;
  ExpenseError({required this.errorMsg});
}
