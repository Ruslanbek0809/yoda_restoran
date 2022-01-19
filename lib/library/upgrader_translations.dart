import 'package:upgrader/upgrader.dart';

class MyTurkmenMessages extends UpgraderMessages {
  @override
  String get title => 'Täze wersiýa!';
  @override
  String get body => 'Ýoda Restoran programmasynyň täze wersiýasy ýüklendi!';
  @override
  String get prompt => 'Täzelemekçimi?';
  @override
  String get buttonTitleIgnore => 'ÝAP';
  @override
  String get buttonTitleLater => 'SOŇRAK';
  @override
  String get buttonTitleUpdate => 'TÄZELE';
}

class MyRussianMessages extends UpgraderMessages {
  @override
  String get title => 'Новая версия!';
  @override
  String get body => 'Доступна новая версия приложении Ýoda Restoran!';
  @override
  String get prompt => 'Хотите обновить?';
  @override
  String get buttonTitleIgnore => 'Закрыть';
  @override
  String get buttonTitleLater => 'Позже';
  @override
  String get buttonTitleUpdate => 'Обновить';
}
