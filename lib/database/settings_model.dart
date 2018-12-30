

class Settings{
  int _id;
  String _lang;

  Settings(this._lang);

  Settings.empty();

  int get id => _id;

  set lang(String lang) => this._lang = lang;
  String get lang => this._lang;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map = {
      'lang': this._lang
    };
    if(_id != null) map['id'] = _id;

    return map;
  }

  Settings.Map(Map object){
    this._id = object['id'];
    this._lang = object['lang'];
  }
}