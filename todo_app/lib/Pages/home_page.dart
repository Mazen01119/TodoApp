import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Components/button.dart';
import 'package:todo_app/Components/task_card.dart';

import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Pages/goal_page.dart';
import 'package:todo_app/Pages/sinlge_task_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFirstGoalEmpty = true;
  bool isSecondGoalEmpty = true;
  bool isThirdGoalEmpty = true;
  DateTime? selectedDate = DateTime.now();
  String? selectedValue = "1";
  String? selected;
  List<int> numbers = [1,2,3];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  String firstName = "";
  bool isLoading = true;
  List<String> goalNames = [];



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

 void showAddTaskDialog() async {
  showDialog(
    context: context,
    builder: (context) {
      titleController.clear();
      descriptionController.clear();
      return AlertDialog(
        title: Text("Add Task", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  TextFormField(
                    maxLength: 40,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Task Title",
                      hintText: "Enter the title of the task",
                    ),
                  ),
                  const SizedBox(height: 10), 
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Task Description",
                      hintText: "Enter a brief description",
                    ),
                    maxLines: 4,
                    maxLength: 150, // Allow multiline input
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Task Due Date",
                      hintText: "Pick a date",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context), // Call your date picker function here
                      ),
                    ),
                    readOnly: true, // Prevent manual input
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedValue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Priority",
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: "1",
                        child: Text("1 (Low)"),
                      ),
                      DropdownMenuItem<String>(
                        value: "2",
                        child: Text("2 (Medium)"),
                      ),
                      DropdownMenuItem<String>(
                        value: "3",
                        child: Text("3 (High)"),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {

                        selectedValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selected,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Goal",
                    ),
                      items: goalNames.map<DropdownMenuItem<String>>((String item) {
    return DropdownMenuItem<String>(
      value: item
      ,
      child: Text(item),
    );
  }).toList(),
                    
                    
                  
                    onChanged: (String? newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20), // Extra space before the button
                  MyButton(
                    title: "Add Task",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //DateTime simplified = DateTime(0, selectedDate!.month, selectedDate!.day);
                        databaseProvider.addTaskToGoal(titleController.text, descriptionController.text, selectedDate, int.parse(selectedValue!), selected!);
                        // Handle form submission
                        Navigator.of(context).pop(); // Close the dialog
                        titleController.clear();
                        descriptionController.clear();
                       
              
                      }
                    },
                   
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadHomePage();
  }

  Future<void> loadHomePage() async {
    // get users first name 
    firstName = person.get('firstName');

    // get goals list
    goalNames = await databaseProvider.getGoals();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: isLoading ? Text("Hello, User") : Text("Hello, " + firstName),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
        
      ),
      body: Column(
        children: [
         Divider(),
         isLoading ? const CircularProgressIndicator() : Expanded(
           child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                   children: [
            goalBox.length>0 ?  Column(
              children: [
               GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoalPage(goalIndex: 0,tasks: listeningProvider.myGoals[0].goalTasks, goalTitle:listeningProvider.myGoals[0].goalName ,)));
                },
                 child:  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(alignment: Alignment.centerLeft, child:  Text(listeningProvider.myGoals[0].goalName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                        Text(databaseProvider.firstGoalCompletionRate.toStringAsFixed(2) + " %", style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
               ),
                Container(
                  color: Color(0xFF9BDBE5).withOpacity(0.4),
                  height: 180,
                  width: double.infinity,
                  child: listeningProvider.myGoals[0].goalTasks.length == 0 ? Container(color: Colors.transparent, child: Center(child: Text("No current Tasks", style: TextStyle(fontWeight: FontWeight.bold),),),) : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listeningProvider.myGoals[0].goalTasks.length,
                    itemBuilder: (context, index) {
                      if(listeningProvider.myGoals[0].goalTasks[index].isCompleted == true){
                        return SizedBox.shrink();
                      } else{
                        
                        
                        return  Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: GestureDetector(child: 
                         
                        MyTaskCard(task: listeningProvider.myGoals[0].goalTasks[index] , goalIndex: 0), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingleTaskPage(task: listeningProvider.myGoals[0].goalTasks[index], goalIndex: 0)));}),
                      );
                      
                      }
                  }),
                ),
               const SizedBox(height: 20,)
              ],
            )  : Container(),
           
            goalBox.length>1 ? Column(
              children: [
                GestureDetector(
                   onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoalPage(goalIndex: 1,tasks: listeningProvider.myGoals[1].goalTasks, goalTitle:listeningProvider.myGoals[1].goalName ,)));
                },
                  child: Padding(
                    padding:  EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(alignment: Alignment.centerLeft, child:  Text(listeningProvider.myGoals[1].goalName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                        Text(databaseProvider.secondGoalCompletionRate.toStringAsFixed(2) + " %", style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Color(0xFF9BDBE5).withOpacity(0.4),
                  height: 180,
                  width: double.infinity,
                  child:  listeningProvider.myGoals[1].goalTasks.length == 0 ? Container(color: Colors.transparent, child: Center(child: Text("No current Tasks", style: TextStyle(fontWeight: FontWeight.bold),),),) : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listeningProvider.myGoals[1].goalTasks.length,
                    itemBuilder: (context, index) {
                      if(listeningProvider.myGoals[1].goalTasks[index].isCompleted == true){
                        return SizedBox.shrink();
                      }
                      return   Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: GestureDetector(child: MyTaskCard(task: listeningProvider.myGoals[1].goalTasks[index], goalIndex: 1,), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingleTaskPage(task: listeningProvider.myGoals[1].goalTasks[index], goalIndex: 1)));},),
                      );
                  }),
                ),
                 SizedBox(height: 20,)
           
              ],
            ) : Container(),
           
            goalBox.length>2 ? Column(
              children: [
                 GestureDetector(
                   onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoalPage(goalIndex: 2,tasks: listeningProvider.myGoals[2].goalTasks, goalTitle:listeningProvider.myGoals[2].goalName ,)));
                },
                   child: Padding(
                    padding:  EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(alignment: Alignment.centerLeft, child:  Text(listeningProvider.myGoals[2].goalName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      Text(databaseProvider.thirdGoalCompletionRate.toStringAsFixed(2) + " %", style: TextStyle(fontSize: 20),)
                      ],
                    ),
                                 ),
                 ),
                Container(
                  color: Color(0xFF9BDBE5).withOpacity(0.4),
                  height: 180,
                  width: double.infinity,
                  child:  listeningProvider.myGoals[2].goalTasks.length == 0 ? Container(color: Colors.transparent, child: Center(child: Text("No current Tasks", style: TextStyle(fontWeight: FontWeight.bold),),),) : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listeningProvider.myGoals[2].goalTasks.length,
                    itemBuilder: (context, index) {
                       if(listeningProvider.myGoals[2].goalTasks[index].isCompleted == true){
                        return SizedBox.shrink();
                      }
                      return   Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: GestureDetector(child: MyTaskCard(task: listeningProvider.myGoals[2].goalTasks[index], goalIndex: 2, ), onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingleTaskPage(task: listeningProvider.myGoals[2].goalTasks[index], goalIndex: 2)));}),
                      );
                  }),
                ),
                const SizedBox(height: 20,)
              ],
            ) : Container(),
           
                   
                   ],
                 ),
         ),],

      ),
      floatingActionButton: FloatingActionButton(onPressed: showAddTaskDialog, child: Icon(Icons.add_task),backgroundColor: Colors.blue,),
    );
  }
}