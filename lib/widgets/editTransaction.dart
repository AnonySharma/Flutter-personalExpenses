import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class EditTransaction extends StatefulWidget {
  final Function addTransaction;
  final Function delTxn;
  final Transaction prevData;
  EditTransaction(this.addTransaction, this.delTxn, this.prevData);

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  var editTitleController = TextEditingController();
  var editAmountController = TextEditingController();
  DateTime pickedDate;
  bool errorTitle = false;
  bool errorAmount = false;

  void _editTxn() {
    if (editAmountController.text.isEmpty && editTitleController.text.isEmpty) {
      setState(() {
        errorTitle = true;
        errorAmount = true;
      });
      return;
    }

    if (editAmountController.text.isEmpty) {
      setState(() {
        errorAmount = true;
      });
      return;
    }

    if (editTitleController.text.isEmpty) {
      setState(() {
        errorTitle = true;
      });
      return;
    }

    final _enteredTitle = editTitleController.text;
    final _enteredAmount = double.parse(editAmountController.text);
    final _enteredDate = pickedDate == null ? widget.prevData.date : pickedDate;

    if (_enteredAmount <= 0) {
      setState(() {
        errorAmount = true;
      });
      return;
    }

    widget.addTransaction(
      _enteredTitle,
      _enteredAmount,
      _enteredDate,
    );

    widget.delTxn(widget.prevData.id);
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: widget.prevData.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;

      setState(() {
        pickedDate = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    editTitleController = TextEditingController(text: widget.prevData.title);
    editAmountController = TextEditingController(text: widget.prevData.amount.toString());
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
                controller: editTitleController,
                onChanged: (_) {
                  setState(() {
                    errorTitle = false;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    errorText: errorTitle ? 'Title can\'t be empty.' : null,),
              ),
              TextField(
                autocorrect: false,
                controller: editAmountController,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  setState(() {
                    errorAmount = false;
                  });
                },
                onSubmitted: (_) => _editTxn(),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  errorText: errorAmount ? 'Amount must be atleast 0.' : null),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pickedDate == null
                        ? DateFormat.yMMMd().format(widget.prevData.date)
                        : DateFormat.yMMMd().format(pickedDate),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _datePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () => _editTxn(),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Edit Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
