import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Components/button.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Data/task.dart';

class SingleTaskPage extends StatelessWidget {
  final Task task;
  final int goalIndex;
  const SingleTaskPage({super.key, required this.task, required this.goalIndex});
  

  @override
  Widget build(BuildContext context) {
    String formatted = DateFormat('dd/MM').format(task.dueDate!);
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen:false);
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.blue,),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Text(task.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    
          
                Container(
                  height: 300,
                  width: 340,
                  color: Colors.teal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(text:  TextSpan(children: [
                      TextSpan(text: "Due Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      TextSpan(text: "$formatted\n", style: TextStyle(fontSize: 18)),
                      TextSpan(text: "Priority: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      TextSpan(text: task.priority.toString() +"\n", style: TextStyle(fontSize: 18)),
                      TextSpan(text: "Description: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      TextSpan(text: task.description+ "\n", style: TextStyle(fontSize: 18))
                    ])),
                  ),
                ),
                const SizedBox(height: 10,),
                MyButton(title: "Complete", onPressed: () async {
                  await databaseProvider.updateTaskCompletion(goalIndex, task);
                  Navigator.of(context).pop();
                }),
                const SizedBox(height: 20,),
                MyButton(title: "Delete", onPressed: () async {
                  await databaseProvider.deleteTask(goalIndex, task);
                  Navigator.of(context).pop();
                })
            ],
          ),
        ),
      ),
    );
  }
}