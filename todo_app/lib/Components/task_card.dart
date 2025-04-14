import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Data/task.dart';
import 'package:todo_app/Pages/home_page.dart';

class MyTaskCard extends StatelessWidget {
  final int goalIndex;
  final Task task;
  const MyTaskCard({super.key, required this.task, required this.goalIndex});

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen:false);
    String formatted = DateFormat('dd/MM').format(task.dueDate!);
    return Container(
      height: 143,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: task.priority == 1 ? Colors.green : task.priority == 2 ? Colors.yellow : Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            
            Text(task.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            
           SizedBox(height: 5,),
            
              //  RichText(text: const TextSpan(
              //   children: [
              //     TextSpan(text: "Date: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  // TextSpan(text: "Insert Task Date\n"),
              //     // TextSpan(text: "Progress: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              //     // TextSpan(text: "Insert Task Progress\n"),
              //     // TextSpan(text: "Approx. Time: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              //     // TextSpan(text: "Insert Task Approx Time \n"),
              //   ],
              // )),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  children: [
                    Text("Due Date: ",  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontStyle: FontStyle.italic, )),
                    Text(formatted, style: TextStyle(fontStyle: FontStyle.italic, ),),
                  ],
                ),
              ),
              
            Spacer(),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                width: 140,
                child: ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),onPressed: () async {

                    await databaseProvider.updateTaskCompletion(goalIndex, task);
                    
                }, child: Text("Complete",style: TextStyle(fontSize: 14, color: Colors.white), ))),
            ),
          ],
        ),
      ),
    );
  }
}