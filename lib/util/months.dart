
final List months = <Map>[
  {'name': 'January', 'abbreviation': 'Jan.', 'number': 1, 'days': 31},
  {'name': 'February', 'abbreviation': 'Feb.', 'number': 2, 'days': 29},
  {'name': 'March', 'abbreviation': 'Mar.', 'number': 3, 'days': 31},
  {'name': 'April', 'abbreviation': 'Apr.', 'number': 4, 'days': 30},
  {'name': 'May', 'abbreviation': 'May.', 'number': 5, 'days': 31},
  {'name': 'June', 'abbreviation': 'Jun.', 'number': 6, 'days': 30},
  {'name': 'July', 'abbreviation': 'Jul.', 'number': 7, 'days': 31},
  {'name': 'August', 'abbreviation': 'Aug.', 'number': 8, 'days': 31},
  {'name': 'Septembre', 'abbreviation': 'Sept.', 'number': 9, 'days': 30},
  {'name': 'Octobre', 'abbreviation': 'Oct.', 'number': 10, 'days': 31},
  {'name': 'Novembre', 'abbreviation': 'Nov.', 'number': 11, 'days': 30},
  {'name': 'December', 'abbreviation': 'Dec.', 'number': 12, 'days': 31},
];

Map findMonthByNumber(int number){
  return months.where((m) => m['number'] == number).toList()[0];
}