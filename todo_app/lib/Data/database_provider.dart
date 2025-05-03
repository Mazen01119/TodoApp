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
  double firstGoalCompletionRate = 0;
  double secondGoalCompletionRate = 0;
  double thirdGoalCompletionRate = 0;

  Future<List<String>> getGoals() async {
    int completedTaskCount = 0;
    _goalNames = [];
    _myGoals = await db.getMyGoalsFromDatabase();

    for(int i =0; i<myGoals.length; i++){
      Goal goal = myGoals[i];
      _goalNames.add(goal.goalName);
      for(Task task in goal.goalTasks){
        if(task.isCompleted == true){
          completedTaskCount++;
        }}
        switch(i){
          
          case 0: 
          print("tried caluclating firstgoalcompletionrate");
            firstGoalCompletionRate = (completedTaskCount / goal.goalTasks.length) *100;
            completedTaskCount = 0;
            break;
          case 1:
          print("tried caluclating secondgoalcompletionrate");
            secondGoalCompletionRate = (completedTaskCount / goal.goalTasks.length) * 100;
            completedTaskCount = 0;
            break;
          case 2: 
          print("tried caluclating thirdgoalcompletionrate");
            thirdGoalCompletionRate = (completedTaskCount / goal.goalTasks.length) * 100;
            print("$thirdGoalCompletionRate + $completedTaskCount + $goal.goalTasks.length ");
            completedTaskCount = 0;
            break;
          default: 
            break;
        }
      
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

Future<void> deleteTask(int goalIndex, Task task) async {
  await db.deleteTaskFromDatabase(goalIndex, task);
  await getGoals();
}

Future<void> untoggleTaskCompletion(int goalIndex, Task task) async {
  task.isCompleted = false;
  await db.untoggleTaskCompletionInDatabase(goalIndex, task);
  await getGoals();
}

}