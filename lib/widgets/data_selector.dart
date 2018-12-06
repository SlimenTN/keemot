import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  final List months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'Septembre',
    'Octobre',
    'Novembre',
    'December'
  ];

  List<Widget> _buildMonthsGrid(){
    List<Widget> list = <Widget>[];
    months.forEach((month) {
      print(month);
      list.add(
        GestureDetector(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                month,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            
            decoration: BoxDecoration(
              // border: Border.all(
              //   // width: 0.5,
              //   color: Colors.grey,
              // ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 3.0),
                  blurRadius: 5.0,
                  spreadRadius: 1.5
                )
              ]
            )
          ),
          onTap: (){
            print(month);
          },
        )
      );
    });

    return list;
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    print('${(itemWidth / itemHeight)}');
    return TabBarView(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          children: _buildMonthsGrid(),
        ),
        Container(
          child: Center(
            child: Text('Second page'),
          ),
        )
      ],
    );
  }
}