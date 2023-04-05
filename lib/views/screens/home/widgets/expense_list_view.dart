import 'package:flutter/material.dart';
import 'package:my_wallet/views/screens/home/widgets/widgets.dart';

import '../../../../controllers/expense_cubit/expense_cubit.dart';
import '../../../../models/models.dart';

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
