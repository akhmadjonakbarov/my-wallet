import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  DateTime _selectedDateOfExpense = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 10,
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Price",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date: ${DateFormat("d MMMM, y").format(
                _selectedDateOfExpense,
              )}"),
              // Text(""),
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: _selectedDateOfExpense,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2099),
                  ).then((value) {
                    setState(() {
                      _selectedDateOfExpense = value!;
                    });
                  });
                },
                child: const Text("Select Date"),
              )
            ],
          )
        ],
      ),
    );
  }
}
