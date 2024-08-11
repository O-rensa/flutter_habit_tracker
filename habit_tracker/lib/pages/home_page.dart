import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).getAllHabits();
  }

  // create a new habit
  void createNewHabit() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),

        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;
              
              // save to db
              context.read<HabitDatabase>().createHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },

            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },

            child: const Text('Cancel'),
          ),

        ],
      ),
    );
  }

  // check habit on and off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }


  // edit habit
  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;

              context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
              
              Navigator.pop(context);

               textController.clear();
            },

            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);

               textController.clear();
            },

            child: const Text('Cancel'),
          ),

        ],
      )
    );
  }

  // delete habit
  void deletHabitbox(Habit habit) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits; 

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // get habit by index
        final habit = currentHabits[index];

        // check if the habit is completed today
        final isCompleted = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return HabitTile(
          habitName: habit.name,
          isCompleted: isCompleted,
          onChanged: (value) => checkHabitOnOff(value, habit), 
          editHabit: (value) => editHabitBox(habit),
          deleteHabit: (value) => deletHabitbox(habit),
        );       
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // styles

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      drawer: const MyDrawer(),   
      body: _buildHabitList(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,

        child: Icon(
          color: Theme.of(context).colorScheme.inversePrimary,

          Icons.add,
          ),
      ),
    );
  }
}