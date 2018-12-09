import 'package:flutter/material.dart';
import '../util/months.dart' as mu;

class DateSelector extends StatefulWidget {
  final Function onDateSelected;
  final int selectedMonth;
  final int selectedDay;
  DateSelector({Key key, @required this.onDateSelected, this.selectedMonth, this.selectedDay}) : super(key: key);
  
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  
  Map _selectedMonth;
  int _selectedDay;
  bool _daysView = false;
  final List months = mu.months;

  @override
  void initState(){
    super.initState();
    if(widget.selectedDay != null){
      _selectedDay = widget.selectedDay;
      _selectedMonth = mu.findMonthByNumber(widget.selectedMonth);
      _daysView = true;
    }
  }

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
                month['abbreviation'],
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
      childAspectRatio: 1.5,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
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
              fontSize: 15.0
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.purple,
          // borderRadius: BorderRadius.circular(10.0)
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
                  fontSize: 10.0
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
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.2,
            mainAxisSpacing: 0.2,
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
      height: 280.0,
      child: Center(
        child: (!_daysView) ? buildMonthsWidget() : buildDaysWidget(),
      ),
    );
  }
}