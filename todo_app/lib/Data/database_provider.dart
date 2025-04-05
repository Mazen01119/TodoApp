import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Data/database_services.dart';
import 'package:todo_app/Data/goal.dart';
import 'package:todo_app/Data/task.dart';
class DatabaseProvider  extends ChangeNotifier{

final db = DatabaseServices();
  // adding a goal 
  Future<void> addGoal({required String goalName}) async {
    Goal goal = Goal(goalId: '', goalName: goalName);
    await db.addGoalToDatabase(goal);
  }

  // Removing a goal 
  Future<void> removeGoal(int index) async {
    await db.removeGoalFromDatabase(index);
  }

  // adding task to a goal
  Future<void> addTaskToGoal(String title, String description, DateTime? dueDate, int priority, String goalName) async {
    late int goalIndex;
    for(int i =0; i<_myGoals.length; i++) {
     Goal goal = goalBox.getAt(i);
     if(goal.goalName == goalName) {
      goalIndex = i;
      break;
     } else {
      print("No goal found");
     }
    }
    Task task = Task(title: title, description: description, priority: priority, isCompleted: false, dueDate: dueDate);
    await db.addTaskToGoalInDatabase(task, goalIndex);
    await getGoals();
  }

  // get goals
  List<Goal> _myGoals = [];
  List<Goal> get myGoals => _myGoals;
  List<String> _goalNames = [];
  List<String> get goalNames =>_goalNames;
  Future<List<String>> getGoals() async {
    _goalNames = [];
    _myGoals = await db.getMyGoalsFromDatabase();
    for(Goal goal in _myGoals) {
      _goalNames.add(goal.goalName);
    }
    
    notifyListeners();
    return goalNames;
  }


 // update Task Completion 
 Future<void> updateTaskCompletion(int goalIndex, Task task) async {
//  for(int i=0; i<_myGoals[goalIndex].goalTasks.length; i++){
//       if(_myGoals[goalIndex].goalTasks[i].title == task.title){
//         _myGoals[goalIndex].goalTasks[i].isCompleted = true;
//       }
//     }


  task.isCompleted = true;
  await db.updateTaskCompletionInDatabase(goalIndex, task);
  await getGoals();

 }


}