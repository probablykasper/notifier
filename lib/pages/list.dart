import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/globals.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[800],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            // backgroundColor: Colors.black26,
            floating: false,
            snap: false,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Notifier',
                style: TextStyle(
                  color: Globals.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              titlePadding: EdgeInsets.only(left: 72, bottom: 16),
            ),
          ),
          // LIST GOES HERE
        ],
      ),
    );
  }
}

