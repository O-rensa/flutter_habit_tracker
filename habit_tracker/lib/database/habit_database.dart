import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }


  // save the first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // List of habits
  final List<Habit> currentHabits = [];

  // create habit
  Future<void> createHabit(String habitName) async {
    // create new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    
    // get all habits from db 
    getAllHabits();
  }

  // get all habits
  Future<void> getAllHabits() async {
    // query all habbits
    List<Habit> query = await isar.habits.where().findAll();

    // assign to currentHabits
    currentHabits.clear();
    currentHabits.addAll(query);

    // update UI
    notifyListeners();
  }

  // check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update the completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add the current date tot the completedDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          // add the current date if it's not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } 
        // if habit is not completed -> remove the current date from the list
        else {
          // remove the current date
          habit.completedDays.removeWhere(
            (date) => 
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day,
          );
        }

        // save the dupdate habits back to db
        await isar.habits.put(habit);
      });
    }

    // get all habits from db
    getAllHabits();
  }

  // edit habit
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;
        // save habit back to db
        await isar.habits.put(habit);
      });
    }

    // get all habits from db
    getAllHabits();
  }

  // delete habit
  Future<void> deleteHabit(int id ) async {
    // perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // get all habit
    getAllHabits();
  }
}