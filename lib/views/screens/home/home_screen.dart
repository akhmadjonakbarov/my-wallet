import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:month_picker_dialog/month_picker_dialog.dart';

import './widgets/widgets.dart';
import '../../../controllers/expense_cubit/expense_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  DateTime _selectedDate = DateTime.now();
  double totalSum = 0.0;
  double totalSumPercentage = 0.0;
  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  void showCalendar() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(2020),
      initialDate: DateTime.now(),
      lastDate: null,
    ).then((selectedDate) {
      setState(() {
        _selectedDate = selectedDate!;
      });
    });
  }

  void previousMonth() {
    if (_selectedDate.year == 2020 && _selectedDate.month == 1) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month - 1,
        _selectedDate.day,
      );
    });
    BlocProvider.of<ExpenseCubit>(context).filterByMonth(
      dateTime: _selectedDate,
    );
  }

  void nextMonth() {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        _selectedDate.day,
      );
    });
    BlocProvider.of<ExpenseCubit>(context).filterByMonth(
      dateTime: _selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ExpenseCubit>(context)
        .totalExpenseByMonth(dateTime: _selectedDate)
        .then((value) {
      setState(() {
        totalSum = value;
        totalSumPercentage = totalSum * 100 / 1000000;
        totalSumPercentage =
            totalSumPercentage > 100 ? 100 : totalSumPercentage;
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(
              totalSum: totalSum,
              showCalendar: showCalendar,
              previousMonth: previousMonth,
              nextMonth: nextMonth,
              selectedDate: _selectedDate,
              size: size,
            ),
            Container(
              decoration: const BoxDecoration(),
              height: size.height * 0.68,
              child: LayoutBuilder(
                builder: (p0, p1) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        width: double.infinity,
                        height: p1.maxHeight,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 227, 227, 240),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("Oylik budjet:"),
                                    TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 25,
                                              ),
                                              child: Column(
                                                children: [
                                                  const TextField(
                                                    decoration:
                                                        InputDecoration(),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child:
                                                            const Text("Enter"),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "1000000",
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    "${totalSumPercentage.toStringAsFixed(0)}%")
                              ],
                            ),
                            ProgressBar(
                              totalSumPer: totalSumPercentage,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          width: p1.maxWidth,
                          height: p1.maxHeight * 0.86,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45),
                            ),
                          ),
                          child: BlocBuilder<ExpenseCubit, ExpenseState>(
                            builder: (context, state) {
                              if (state is ExpenseLoaded) {
                                return ExpenseListView(
                                  state: state,
                                );
                              } else if (state is ExpenseError) {
                                return Center(
                                  child: Text(
                                    state.errorMsg.toString(),
                                    style: GoogleFonts.nunito(),
                                  ),
                                );
                              } else if (state is ExpenseLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return Center(
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child: Text(
                                      "Information is not available!",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: false,
            context: context,
            builder: (context) {
              return const AddExpense();
            },
          );
        },
        child: const Icon(
          CupertinoIcons.add,
        ),
      ),
    );
  }
}
