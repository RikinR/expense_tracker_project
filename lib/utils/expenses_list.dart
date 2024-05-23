import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {required this.deleteItem, required this.expenseList, super.key});
  final List<Expense> expenseList;
  final void Function(Expense expense) deleteItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                shape: BoxShape.rectangle),
          ),
          key: ValueKey(expenseList[index]),
          onDismissed: (direction) {
            deleteItem(expenseList[index]);
          },
          child: ExpenseItem(expense: expenseList[index])),
    );
  }
}
