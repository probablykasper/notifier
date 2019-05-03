import 'package:flutter/material.dart';

import 'package:notifier/notifier_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Update',
      theme: ThemeData(
        
        fontFamily: 'Rubik',
        brightness: Brightness.dark,
        // backgroundColor: Colors.blue,
      ),
      home: Scaffold(
        // appBar: SliverAppBar(
        //   centerTitle: true,
        //   title: Text('Text Upper Dapper'),
        // ),
        // body: Container(
        //   child: Text('hey'),
        // ),
        body: NotifierList(),
      ),
    );
  }
}
