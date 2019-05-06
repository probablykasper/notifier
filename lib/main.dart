import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/list.dart';
import 'package:notifier/pages/list.dart';

void main() {
  final list = ListModel();
  runApp(ScopedModel<ListModel>(
    model: list,
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifier',
      home: ListPage(),
    );
  }
}
