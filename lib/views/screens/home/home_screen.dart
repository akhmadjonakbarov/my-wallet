import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';

import './widgets/widgets.dart';

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

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  void showCalendar() {
    // showMonthPicker(
    //   context: context,
    //   firstDate: DateTime(2020),
    //   initialDate: DateTime.now(),
    //   lastDate: null,
    // ).then((selectedDate) {
    //   setState(() {
    //     _selectedDate = selectedDate!;
    //   });
    // });
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
  }

  void nextMonth() {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        _selectedDate.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Wallet'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Header(
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      "100,000",
                                    ),
                                  ),
                                ],
                              ),
                              const Text("4%")
                            ],
                          ),
                          const ProgressBar()
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
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              title: const Text(
                                "Tarvuz",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat("d MMMM, y").format(
                                  DateTime.now(),
                                ),
                              ),
                              trailing: const Text("20,000 so'm"),
                            );
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
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showModalBottomSheet(
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
