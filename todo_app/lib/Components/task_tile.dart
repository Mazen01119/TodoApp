import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Data/task.dart';
import 'package:todo_app/Pages/home_page.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int goalIndex;
  const TaskTile({super.key, required this.task, required this.goalIndex});

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen:false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: IconButton(onPressed: ()async {
            await databaseProvider.updateTaskCompletion(goalIndex, task);
            Navigator.of(context).pop();
          }, icon: Icon(Icons.check_box_outline_blank)),
          title: Text(task.title),
          
        ),
      ),
    );
  }
}