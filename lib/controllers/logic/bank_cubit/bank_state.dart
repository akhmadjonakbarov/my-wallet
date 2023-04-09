// ignore_for_file: must_be_immutable

part of 'bank_cubit.dart';

abstract class BankState extends Equatable {
  List<Bank>? banks;
  BankState({this.banks});

  @override
  List<Object> get props => [];
}

class BankInitial extends BankState {}

class BankWelcome extends BankState {}

class BankLoaded extends BankState {
  final List<Bank> banks;
  BankLoaded({required this.banks});
}

class BankError extends BankState {
  final String errorMsg;
  BankError({required this.errorMsg});
}
