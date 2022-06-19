import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/transaction.dart';

class ExpenseChart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const ExpenseChart({Key key, this.recentTransactions}) : super(key: key);

  /// Create one series with sample hard coded data.
  List<charts.Series<Transaction, String>> _createSampleData() {
    return [
      new charts.Series<Transaction, String>(
        id: 'Expenses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Transaction expenses, _) => expenses.title,
        measureFn: (Transaction expenses, _) => expenses.amount,
        data: recentTransactions,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.width / 2,
      child: new charts.BarChart(
        _createSampleData(),
        animate: true,
      ),
    );
  }
}
