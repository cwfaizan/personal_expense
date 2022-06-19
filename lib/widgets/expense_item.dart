import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class ExpenseItem extends StatelessWidget {
  final Transaction userTransaction;
  final Function deleteTransaction;
  final mediaQuery;

  const ExpenseItem(
      {Key key, this.userTransaction, this.deleteTransaction, this.mediaQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${userTransaction.amount}'),
            ),
          ),
        ),
        title: Text(
          userTransaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(userTransaction.date),
        ),
        trailing: mediaQuery.size.width > 460
            ? TextButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
                onPressed: () => deleteTransaction(
                  userTransaction.id,
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(
                  userTransaction.id,
                ),
              ),
      ),
    );
  }
}
