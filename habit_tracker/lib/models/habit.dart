import 'package:isar/isar.dart';

// run cmd => dart run build_runner build
part "habit.g.dart";

@Collection()
class Habit {
  Id id = Isar.autoIncrement;

  late String name;

  List<DateTime> completedDays = []; // DateTime(year, month, day)
}