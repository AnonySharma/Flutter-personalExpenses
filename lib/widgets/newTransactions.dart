import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransactionFun;
  NewTransaction(this.newTransactionFun);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime pickedDate;
  bool errorAmount = false;
  bool errorTitle = false;

  void _createTxn() {
    if (amountController.text.isEmpty && titleController.text.isEmpty) {
      setState(() {
        errorTitle=true;
        errorAmount=true;
      });
      return;
    }

    if (amountController.text.isEmpty) {
      setState(() {
        errorAmount=true;
      });
      return;
    }

    if(titleController.text.isEmpty) {
      setState(() {
        errorTitle=true;
      });
      return;
    }

    final _enteredTitle = titleController.text;
    final _enteredAmount = double.parse(amountController.text);
    final _enteredDate = pickedDate == null ? DateTime.now() : pickedDate;

    if(_enteredAmount <= 0 ) {
      setState(() {
        errorAmount=true;
      });
      return;
    }

    widget.newTransactionFun(
      _enteredTitle, 
      _enteredAmount,
      _enteredDate,
    );

    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),
    ).then((value) {
        if (value == null)
          return;

        setState(() {
          pickedDate=value;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                autocorrect: false, 
                controller: titleController,
                onChanged: (_) {
                  setState(() {
                    errorTitle = false;
                  });
                },
                decoration: InputDecoration(labelText: "Title", errorText: errorTitle ? 'Title can\'t be empty.' : null),
              ),
              TextField(
                autocorrect: false, 
                keyboardType: TextInputType.number,
                controller: amountController,
                onChanged: (_) {
                  setState(() {
                    errorAmount = false;
                  });
                },
                onSubmitted: (_) => _createTxn(),
                decoration: InputDecoration(labelText: "Amount", errorText: errorAmount ? 'Amount must be atleast 0.' : null),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pickedDate == null ? 
                      DateFormat.yMMMd().format(DateTime.now()) : 
                      DateFormat.yMMMd().format(pickedDate),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _datePicker, 
                      child: Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _createTxn, 
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
                child: Text("Add Transaction",),
              ),
            ],
          ),
        ),
      ),
    );
  }
}