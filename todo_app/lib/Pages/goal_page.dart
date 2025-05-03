import 'package:flutter/material.dart';
import 'package:todo_app/Components/task_tile.dart';
import 'package:todo_app/Data/task.dart';

class GoalPage extends StatefulWidget {
  final int goalIndex;
  List<Task> tasks;
  final String goalTitle;
   GoalPage({super.key, required this.goalIndex, required this.tasks, required this.goalTitle});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(foregroundColor: Colors.blue, scrolledUnderElevation: 0, backgroundColor: Colors.white,),
      body: Column(
        children: [
           Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Align(alignment: Alignment.centerLeft, child:  Text(widget.goalTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                ),
          Expanded(
            child: widget.tasks.isEmpty ? Container(child: Center(child: Text("No Current Tasks" ,style: TextStyle(fontWeight: FontWeight.bold),),),) : ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(task: widget.tasks[index], goalIndex: widget.goalIndex,);
              }),
          ),
        ],
      ),
    );
  }
}