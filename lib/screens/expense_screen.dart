import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/expense_item.dart';
import '../models/transaction.dart';
import '../widgets/expense_chart.dart';
import '../widgets/new_transaction.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];
  bool _showChart = false;

  // List<Transaction> get _recentTransactions {
  //   return _userTransactions.where((tx) {
  //     return tx.date.isAfter(
  //       DateTime.now().subtract(
  //         Duration(days: 7),
  //       ),
  //     );
  //   }).toList();
  // }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        child: _userTransactions.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 200,
                      child: Image.asset(
                        'assets/images/sad.jpg',
                        fit: BoxFit.cover,
                      )),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (isLandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Show Chart'),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: _showChart,
                            onChanged: (val) {
                              setState(() {
                                _showChart = val;
                              });
                            },
                          ),
                        ],
                      ),

                    if (isLandscape && _showChart)
                      Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        child:
                            ExpenseChart(recentTransactions: _userTransactions),
                      ),

                    if (!isLandscape)
                      Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.3,
                        child:
                            ExpenseChart(recentTransactions: _userTransactions),
                      ),

                    Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return ExpenseItem(
                            userTransaction: _userTransactions[index],
                            deleteTransaction: _deleteTransaction,
                            mediaQuery: mediaQuery,
                          );
                        },
                        itemCount: _userTransactions.length,
                      ),
                    ),

                    // Flexible(
                    //   fit: FlexFit.loose,
                    //   child: ,
                    // ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            )
          : Container(),
    );
  }
}
