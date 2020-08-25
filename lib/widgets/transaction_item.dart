import '../models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.editTxn,
    @required this.deleteTxn,
  }) : super(key: key);

  final Transaction transaction;
  final Function editTxn;
  final Function deleteTxn;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30, 
          child: Padding(
              padding: EdgeInsets.all(6),
              child: FittedBox(
                child: Text(
                '₹ ${transaction.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit), 
              splashRadius: 30,
              onPressed: () => editTxn(transaction.id),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor, 
              splashRadius: 30,
              onPressed: () => deleteTxn(transaction.id),
            ),
          ],
        ),
      ),
    );
  }
}