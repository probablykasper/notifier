import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  final List<String> titles;

  NotificationsList(this.titles);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        titles
            .map((title) => InkWell(
                  onTap: () => print("Someone tapped me and it felt great"),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Title',
                          style: TextStyle(
                            fontSize: 16,
                            // color: Color(0xff00B0FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Description that would be rather long most likelyhat would be rather long most likely',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
