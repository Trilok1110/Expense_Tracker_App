import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/widgets/new_expense/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/modals/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  void _addExpense(Expense expense) {
    setState(() {
      _resisterdExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _resisterdExpenses.indexOf(expense);
    setState(() {
      _resisterdExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _resisterdExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  final List<Expense> _resisterdExpenses = [
    Expense(
        title: 'cinema',
        amount: 20.00,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'stack overflow subcription ',
        amount: 19.00,
        date: DateTime.now(),
        category: Category.work),
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('List is empty. please add Expense'),
    );

    if (_resisterdExpenses.isNotEmpty) {
      mainContent =
          ExpensesList(expenses: _resisterdExpenses, onRemove: _removeExpense);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Expense Tracker',
          ),
          //backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
              color: Colors.white,
            )
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(
                    expenses: _resisterdExpenses,
                  ),
                  Expanded(
                    child: mainContent,
                  )
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(
                      expenses: _resisterdExpenses,
                    ),
                  ),
                  Expanded(
                    child: mainContent,
                  )
                ],
              ));
  }
}
