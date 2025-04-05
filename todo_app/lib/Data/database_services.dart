
import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Data/goal.dart';
import 'package:todo_app/Data/task.dart';

class DatabaseServices {
  
  // adding a goal 
  Future<void> addGoalToDatabase(Goal goal) async {
    goalBox.add(goal);
  }

  // removing a goal
  Future<void> removeGoalFromDatabase(int index) async {
    goalBox.deleteAt(index);
  }

  // Adding a task to a goal
  Future<void> addTaskToGoalInDatabase(Task task, int index) async {
    Goal _goal = goalBox.getAt(index);
    _goal.goalTasks.add(task);
    goalBox.putAt(index, _goal);
  }

  // Get goals
  Future<List<Goal>> getMyGoalsFromDatabase() async {
    return goalBox.values.cast<Goal>().toList();
  }

  Future<void> updateTaskCompletionInDatabase(int goalIndex, Task task) async {
    Goal _goal = goalBox.getAt(goalIndex);
    for(int i=0; i<_goal.goalTasks.length; i++){
      if(_goal.goalTasks[i].title == task.title) {
        _goal.goalTasks.removeAt(i);
      }
      goalBox.putAt(goalIndex, _goal);
      
    }
  }
}