import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.addToList, super.key});
  final void Function(Expense expense) addToList;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _nameTextController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  Categories _selectedCategory = Categories.leisure;

  @override
  void dispose() {
    _nameTextController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_nameTextController.text.trim().isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Invalid Inputs"),
          content: const Text("Please enter valid data !"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );
      return;
    }

    widget.addToList(Expense(
        name: _nameTextController.text,
        amount: enteredAmount,
        date: selectedDate!,
        itemCategory: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          TextField(
            controller: _nameTextController,
            maxLength: 50,
            decoration: const InputDecoration(
                label: Text(
                  "Title",
                  style: TextStyle(color: Colors.white),
                ),
                hintText: "Movie Tickets"),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixText: "Rs. ",
                      label: Text(
                        "Amount",
                        style: TextStyle(color: Colors.white),
                      ),
                      hintText: "30"),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(DateFormat.yMd().format(selectedDate!)),
                    IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 1,
                                DateTime.now().month, DateTime.now().day),
                            lastDate: DateTime.now());
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      },
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                dropdownColor: const Color.fromARGB(255, 58, 74, 105),
                value: _selectedCategory,
                items: Categories.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(
                    () {
                      _selectedCategory = value;
                    },
                  );
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitExpense();
                },
                child: const Text(
                  "Save Expense",
                  style: TextStyle(color: Color.fromARGB(255, 58, 74, 105)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
