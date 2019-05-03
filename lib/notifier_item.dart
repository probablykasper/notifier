import 'package:flutter/material.dart';

class NotifierItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: EdgeInsets.all(16.0),
    //   padding: EdgeInsets.all(16.0),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(10),
    //     ),
    //     border: Border.all(
    //       width: 1,
    //       color: Colors.white24,
    //     ),
    //   ),
    //   child: InkWell(
    //     onTap: () => print("Someone tapped me and it felt great"),
    //     child: Text('list item'),
    //   ),
    // );
    return Container(
      margin: EdgeInsets.all(16.0),
      // alignment: Alignment.centerLeft,
      // color: Colors.lightBlue[100 * (index % 9)],
      child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          onTap: () => print("Someone tapped me and it felt great"),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white10,
            ),
            padding: EdgeInsets.all(16.0),
            child: Text('list item'),
          )
          // child: Text('list item'),
          ),
    );
  }
}
