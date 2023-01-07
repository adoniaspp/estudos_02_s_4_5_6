import 'dart:ui';
import 'dart:io';

import 'package:despesas/models/Transaction.dart';
import 'package:despesas/widgets/chart.dart';
import 'package:despesas/widgets/new_transaction.dart';
import 'package:despesas/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Despesas());
}

class Despesas extends StatelessWidget {
  const Despesas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despesas APP',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
              titleMedium: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              errorColor: Colors.red)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    //Transaction('1', 'Sapatos', 55.85, DateTime.now()),
    //Transaction('2', 'Alimentos', 30.50, DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chossenDate) {
    final newTx =
        Transaction(DateTime.now().toString(), txTitle, txAmount, chossenDate);
    setState(() {
      transactions.add(newTx);
    });
  }

  void _deleteTransactions(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas App'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => startAddNewTransaction(context),
              )
            ]),
          )
        : AppBar(
            title: const Text('Despesas App'),
            actions: [
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => startAddNewTransaction(context),
              )
            ],
          )) as ObstructingPreferredSizeWidget;

    final listTransactions = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(transactions, _deleteTransactions));
    final pageBody = SafeArea(child: SingleChildScrollView(
      child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: ((value) {
                        setState(() {
                          _showChart = value;
                        });
                      }))
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.7,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) listTransactions,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : listTransactions
          ]),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => startAddNewTransaction(context),
                  ),
          );
  }
}
