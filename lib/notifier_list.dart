import 'package:flutter/material.dart';

import 'package:notifier/notifier_item.dart';

class NotifierList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            // centerTitle: true,
            title: Text('Notifier'),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 16.0,
              left: 32.0,
            ),
            // padding: EdgeInsets.all(16.0),
            child: Text('PINNED'),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NotifierItem(),
            ],
          ),
        ),
      ],
    );
  }
}
