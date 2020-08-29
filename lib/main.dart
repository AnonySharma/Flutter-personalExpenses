import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import './widgets/chart.dart';
import './widgets/newTransactions.dart';
import './widgets/listTransactions.dart';
import './widgets/editTransaction.dart';

import './models/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown, 
  //   DeviceOrientation.portraitUp],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;
  
  List<Transaction> get _recentTransaction {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String newTitle, double newAmount, DateTime newDate) {
    
    final newTxn = Transaction(
      title: newTitle, 
      amount: newAmount, 
      date: newDate, 
      id: DateTime.now().toString()
    );

    setState(() {
      _userTransactions.add(newTxn);
    });
  }

  void _deleteTransaction(id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id==id);
    });
  }

  void _startEditTransaction(BuildContext ctx, Transaction prevData) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
        return GestureDetector( 
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: EditTransaction(_addNewTransaction, _deleteTransaction, prevData),
        );
      }
    );
  }

  void _editTransaction(id) {
    Transaction temp;//=_userTransactions.where((element) => element.id==id) as Transaction;
    for (var i = 0; i < _userTransactions.length; i++) {
      if (_userTransactions[i].id==id) {
        temp = _userTransactions[i];
        break;
      }
    }
    setState(() {
      _startEditTransaction(context, temp);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
        return GestureDetector( 
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      }
    );
  }

  // OFFICIAL ABOUT SECTION

  //   void _showAboutDialog2() {
  //   showAboutDialog(
  //       context: context,
  //       applicationName: 'Expenses_App',
  //       applicationIcon: FlutterLogo(),//Image.asset('./assets/launcher/icon.png'),
  //       applicationVersion: '1.4.9',
  //       children: [
  //         Text(
  //           'This is a personal expenses app.It can be used to manage your expenses for the curent week. Hope you will like it.',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             IconButton(icon: Icon(Icons.copyright), onPressed: null),
  //             Text(
  //               'Ankit Kumar Sharma',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         )
  //       ]);
  // }

  Future _showAboutDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          child: Container(
            height: 205,
            margin: EdgeInsets.fromLTRB(14, 0, 14, 5),
            child: Column (
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    IconButton(
                      icon: Icon(Icons.close), 
                      splashColor: Colors.redAccent,
                      splashRadius: 20,
                      onPressed: () => Navigator.of(context).pop()
                    )
                  ],
                ),
                Container(
                  color: Color.fromRGBO(220, 220, 220, 0.8),
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                ),
                Text('Personal Expenses is a handy app which can be quite helpful for students for managing their expenses. It also has a chart which displays expenses in the last 7 days.'),
                SizedBox(
                  height: 10,
                ),
                Text('By: Ankit Kumar Sharma'),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                    },
                    text: "GitHub: https://www.github.com/AnonySharma",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    linkStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.normal),
                  )
                )
              ],
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final ourAppBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
          icon: Icon(Icons.add), 
          onPressed: () => _startAddNewTransaction(context), 
          tooltip: "Add new", 
          splashRadius: 25.0,
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          tooltip: "About",
          splashRadius: 25.0, 
          onPressed: () => _showAboutDialog(),
        )
      ],
    );
    final txnListWidget = Container(
      height: (mediaQuery.size.height - ourAppBar.preferredSize.height - mediaQuery.padding.top) * 0.8,
      child: TransactionList(_userTransactions, _deleteTransaction, _editTransaction),
    );
    return Scaffold(
      appBar: ourAppBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
            if(!isLandscape) Container(
                height: (mediaQuery.size.height - ourAppBar.preferredSize.height - mediaQuery.padding.top) * 0.2,
                child: Chart(_recentTransaction),
              ),
            if(!isLandscape) txnListWidget,

            if(isLandscape) _showChart 
            ? Container(
                height: (mediaQuery.size.height - ourAppBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
                child: Chart(_recentTransaction),
              )
            : txnListWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()  => _startAddNewTransaction(context),
      ),
    );
  }
}