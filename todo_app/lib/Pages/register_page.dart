import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Components/button.dart';
import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Pages/home_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController goalOneController = TextEditingController();
    TextEditingController goalTwoController = TextEditingController();
    TextEditingController goalThreeController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
   


    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextFormField(validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please Enter Your First Name";
                  }
                }, maxLength: 30,controller: firstNameController, decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "First Name",
                          hintText: "Enter your first Name",
                           ),),
              
              const SizedBox(height: 20,),
              
              TextFormField(
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please Your First Goal";
                  }
                },
                maxLength: 30,
                controller: goalOneController, decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Goal 1",
                          hintText: "Enter your first Goal",
                        ),),

               const SizedBox(height: 20,),         
              TextFormField(validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please Enter Your second Goal";
                  }
                }, maxLength: 30, controller:  goalTwoController, decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Goal 2",
                          hintText: "Enter your second Goal",
                        ),),

               const SizedBox(height: 20,),         
              TextFormField(validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please Enter A Value";
                  }
                }, maxLength: 50,  controller: goalThreeController, decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Goal 3",
                          hintText: "Please Enter your third Goal",
                          
                        ),),

              const SizedBox(height: 20,),
              MyButton(title: "Register", onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  await databaseProvider.addGoal(goalName: goalOneController.text);
                  await databaseProvider.addGoal(goalName: goalTwoController.text); 
                  await databaseProvider.addGoal(goalName: goalThreeController.text);
                  await person.put('firstName', firstNameController.text);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                }
              })
                  ],),
          ),
        )),
    );
  }
}