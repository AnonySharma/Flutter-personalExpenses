import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String weekDay;
  final double amount;
  final double percentageOfTotal;

  ChartBar({this.weekDay, this.amount, this.percentageOfTotal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, contraints) {
      return Column(
        children: [
          Container(
            height: contraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('₹ ${amount.toStringAsFixed(0)}',),
            ),
          ),
          SizedBox(height: contraints.maxHeight * 0.05),
          Container(
            height: contraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color:Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentageOfTotal, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: contraints.maxHeight * 0.05),
          Container(
            height: contraints.maxHeight * 0.15,
            child: FittedBox(child: Text(weekDay, style: Theme.of(context).textTheme.headline6),),
          ),
        ],
      );
    });
  }
}