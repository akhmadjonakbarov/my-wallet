import 'package:flutter/material.dart';

import '../../../../controllers/logic/cubits.dart';
import '../../../../models/models.dart';
import './widgets.dart';

class ExpenseListView extends StatelessWidget {
  final ExpenseState state;
  const ExpenseListView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      itemCount: state.expenses!.length,
      itemBuilder: (context, index) {
        Expense expense = state.expenses![index];
        return ExpenseTile(expense: expense);
      },
    );
  }
}
