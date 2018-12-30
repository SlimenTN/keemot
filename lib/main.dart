import 'package:flutter/material.dart';
import 'widgets/coming_stuff.dart';
import 'util/dictionnary.dart' as dictionnary;
import 'database/db_handler.dart';
import 'database/settings_model.dart';

void main(){
  initLang();
  runApp(new MaterialApp(
    home: ComingStufWidget(),
  ));
}

void initLang() async {
  dictionnary.lang = 'en';
  final dbh = DatabaseHandler.internal();
  Settings settings = await dbh.readSettings();
  dictionnary.lang = (settings.lang == null) ? 'en' : settings.lang;
}
