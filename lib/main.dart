import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/expense_cubit/expense_cubit.dart';
import 'views/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ExpenseCubit()),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
