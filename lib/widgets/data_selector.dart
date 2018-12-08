import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  Function onDateSelected;
  DateSelector({Key key, @required this.onDateSelected}) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  
  Map _selectedMonth;
  int _selectedDay;
  bool _daysView = false;
  final List months = <Map>[
    {'name': 'January', 'number': 1, 'days': 31},
    {'name': 'February', 'number': 2, 'days': 29},
    {'name': 'March', 'number': 3, 'days': 31},
    {'name': 'April', 'number': 4, 'days': 30},
    {'name': 'May', 'number': 5, 'days': 31},
    {'name': 'June', 'number': 6, 'days': 30},
    {'name': 'July', 'number': 7, 'days': 31},
    {'name': 'August', 'number': 8, 'days': 31},
    {'name': 'Septembre', 'number': 9, 'days': 30},
    {'name': 'Octobre', 'number': 10, 'days': 31},
    {'name': 'Novembre', 'number': 11, 'days': 30},
    {'name': 'December', 'number': 12, 'days': 31},
  ];

  //Build list of months Grid
  List<Widget> _buildMonthsGrid(){
    List<Widget> list = <Widget>[];
    months.forEach((month) {
      // print('$month');
      list.add(
        InkWell(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                month['name'],
                style: TextStyle(
                  color: (_selectedMonth != null && _selectedMonth['number'] == month['number']) ? Colors.white : Colors.grey,
                ),
              ),
            ),
            
            decoration: BoxDecoration(
              color: (_selectedMonth != null && _selectedMonth['number'] == month['number']) ? Colors.purple : Colors.white,
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
            _selectMonth(month);
          },
        )
      );
    });

    return list;
  }

  //Build months widget
  Widget buildMonthsWidget(){
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      children: _buildMonthsGrid(),
    );
  }

  //Perform month selection
  void _selectMonth(Map month){
    _selectedMonth = month;
    _selectedDay = null;
    _daysView = true;
    setState(() {});
  }

  //Build "Back to months" Widget
  Widget backToMonthsButton(){
    return InkWell(
        child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            'BACK TO MONTHS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      onTap: (){
        goBackToMonthsView();
      },
    );
  }

  //Build list of days Grid
  List<Widget> _buildDaysGrid(){
    var _days = _selectedMonth['days'];
    List<Widget> list = <Widget>[];
    for (var i = 1; i <= _days; i++) {
      list.add(
        InkWell(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: (_selectedDay != null && _selectedDay == i) ? Colors.white : Colors.grey,
                ),
              ),
            ),
            
            decoration: BoxDecoration(
              color: (_selectedDay != null && _selectedDay == i) ? Colors.purple : Colors.white,
              borderRadius: BorderRadius.circular(20.0),
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
            // print('you have selected the $i th of ${_selectedMonth['name']}');
            widget.onDateSelected(_selectedMonth, i);
            setState(() { _selectedDay = i; });
          },
        )
      );
    }

    return list;
  }

  //Build days widget
  Widget buildDaysWidget(){
    return Column(
      children: <Widget>[
        Expanded(
            child: GridView.count(
            crossAxisCount: 7,
            // childAspectRatio: 2.5,
            // crossAxisSpacing: 15.0,
            // mainAxisSpacing: 15.0,
            children: _buildDaysGrid(),
          ),
        ),
        backToMonthsButton()
      ],
    );
  }

  //Back to list of months
  void goBackToMonthsView(){
    _daysView = false;
    setState(() { });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: (!_daysView) ? buildMonthsWidget() : buildDaysWidget(),
      ),
    );
  }
}