import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/globals.dart';
import 'package:notifier/models/list.dart';

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
      body: _List(),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListModel>(
      builder: (context, child, list) {
        return CustomScrollView(
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
            SliverList(
              delegate: SliverChildListDelegate(
                list.items.map((item) {
                  return InkWell(
                    onTap: () => print("Someone tapped me and it felt great"),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 32.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              // color: Color(0xff00B0FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        );
      },
      // builder: (context, child, list) => ListView(
      //       children: list.items
      //           // For each item in the list:
      //           .map(
      //             (item) => Text('· ${item.title}'),
      //           )
      //           .toList(),
      //     ),
    );
  }
}
