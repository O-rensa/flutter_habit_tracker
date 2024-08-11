// give a habit list of completion days
// is the habit completed tody
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any(
    (date) => 
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day 
  );
}