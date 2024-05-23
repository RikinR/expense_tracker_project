import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expense, super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(expense.name),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(" Rs ${expense.amount.toStringAsFixed(2)}"),
                const Spacer(),
                Icon(
                  categoryIcons[expense.itemCategory],
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(expense.getFormattedDate(expense.date))
              ],
            )
          ],
        ),
      ),
    );
  }
}
