import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String habitName;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), 
          children: [
            // edit 
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
      
            // delete
            SlidableAction(
              onPressed: deleteHabit,
      
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
        
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted ? 
              Colors.green : 
              Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(12),
          
            child: ListTile(
              title: Text(
                habitName,
                style: TextStyle(
                  color: isCompleted ?
                  Colors.white :
                  Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
          
                value: isCompleted, 
                onChanged: onChanged
              ),
            ),
          ),
        ),
      ),
    );
  }
}