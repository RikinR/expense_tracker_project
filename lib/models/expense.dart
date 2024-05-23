import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum Categories { work, leisure, food, others }

const categoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.leisure: Icons.flight,
  Categories.others: Icons.luggage,
  Categories.work: Icons.work
};

class Expense {
  Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.itemCategory,
  }) : id = const Uuid().v4();

  final String name;
  final double amount;
  final DateTime date;
  final String id;
  final Categories itemCategory;

  String getFormattedDate(itemDate) {
    return DateFormat.yMd().format(itemDate);
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      itemCategory: Categories.values[json['itemCategory']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'itemCategory': itemCategory.index,
    };
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.itemCategory == category)
            .toList();

  final Categories category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
