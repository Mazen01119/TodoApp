import 'package:hive/hive.dart';
import 'package:todo_app/Data/task.dart';

part 'goal.g.dart'; 

@HiveType(typeId: 0)
class Goal {
  @HiveField(0)
  final String goalId;

  @HiveField(1)
  final String goalName;

  @HiveField(2)
  List<Task> goalTasks;

  Goal({
    required this.goalId,
    required this.goalName,
    List<Task>? tasks,
  }) : goalTasks = tasks ?? []; 
}