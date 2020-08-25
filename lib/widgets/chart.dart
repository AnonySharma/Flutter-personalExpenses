import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/transactions.dart';
import './chartBar.dart';

// ignore: must_be_immutable
class Chart extends StatelessWidget {
  final List<Transaction> recentTxns;
  double sum = 0.0;

  Chart(this.recentTxns);
  List<Map<String,Object>> get getGroupedTxns {
    sum=0.0;
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTxns.length; i++) {
        if(recentTxns[i].date.day == weekDay.day && 
          recentTxns[i].date.month == weekDay.month && 
          recentTxns[i].date.year == weekDay.year) {
            totalSum+=recentTxns[i].amount;
            sum+=recentTxns[i].amount;
          }
      }

      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'total': totalSum};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getGroupedTxns.map((txn) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                weekDay: txn['day'],
                amount: txn['total'],
                percentageOfTotal: sum==0 ? 0 : (txn['total'] as double)/sum
              ),
            );
          }).toList().reversed.toList(),
        ),
      ),
    );
  }
}