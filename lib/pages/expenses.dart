import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/pages/new_expense.dart';
import 'package:expense_tracker/utils/expenses_list.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key, required this.changeTheme}) : super(key: key);
  final Function(bool) changeTheme;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Expense> registeredList = [
    Expense(
      name: "flutter course",
      amount: 499,
      date: DateTime.now(),
      itemCategory: Categories.work,
    ),
    Expense(
      name: "movie",
      amount: 300,
      date: DateTime.now(),
      itemCategory: Categories.leisure,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedExpenses = prefs.getStringList('expenses');
    if (savedExpenses != null) {
      setState(() {
        registeredList = savedExpenses
            .map((json) => Expense.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        registeredList.map((expense) => jsonEncode(expense.toJson())).toList();
    await prefs.setStringList('expenses', jsonList);
  }

  void addToList(Expense expense) {
    setState(() {
      registeredList.add(expense);
    });
    _saveExpenses();
  }

  void deleteExpense(Expense expense) {
    setState(() {
      registeredList.remove(expense);
    });
    _saveExpenses();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(
              () {
                registeredList.add(expense);
              },
            );
            _saveExpenses();
          },
        ),
      ),
    );
  }

  List<ExpenseBucket> _getBuckets() {
    List<ExpenseBucket> buckets = [];
    for (Categories category in Categories.values) {
      buckets.add(ExpenseBucket.forCategory(registeredList, category));
    }
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text("No Expenses yet!"));
    if (registeredList.isNotEmpty) {
      mainContent = ExpenseList(
        expenseList: registeredList,
        deleteItem: deleteExpense,
      );
    }

    List<ExpenseBucket> buckets = _getBuckets();
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Expense Tracker App"),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) => NewExpense(addToList: addToList),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              onThemeChanged: widget.changeTheme,
                              deleteAllExpenses: () {
                                setState(() {
                                  registeredList.clear();
                                });
                                _saveExpenses();
                              },
                            )),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Exit'),
                onTap: () {
                  exit(0);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  title: const ChartTitle(text: 'Expenses by Category'),
                  legend: const Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    ColumnSeries<ExpenseBucket, String>(
                      dataSource: buckets,
                      xValueMapper: (ExpenseBucket bucket, _) =>
                          bucket.category.name,
                      yValueMapper: (ExpenseBucket bucket, _) =>
                          bucket.totalExpenses,
                      name: 'Expenses',
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      pointColorMapper: (_, __) => colorScheme.primary,
                    ),
                  ],
                ),
              ),
              Expanded(child: mainContent),
            ],
          ),
        ),
      ),
    );
  }
}
