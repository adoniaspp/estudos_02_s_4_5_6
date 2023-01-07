import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptativeFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptativeFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: () {
              handler;
            },
            child: Text(
              'Chosse Date',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * MediaQuery.of(context).textScaleFactor),
            ),
          )
        : FlatButton(
            onPressed: () {
              handler;
            },
            child: Text(
              'Chosse Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * MediaQuery.of(context).textScaleFactor),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
