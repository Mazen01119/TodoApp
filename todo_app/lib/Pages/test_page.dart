import 'package:flutter/material.dart';
import 'package:todo_app/Components/button.dart';
import 'package:todo_app/Components/task_card.dart';
import 'package:todo_app/Components/textField.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //MyButton(title: "Hello Sir"),
            SizedBox(height: 30,),
            SizedBox(
              height: 100,
              width: 350,
              child: MyTextField(controller: TextEditingController(), labelText: "Hello",)),
            //  MyTaskCard()
          ],
        ),
      ),
    );
  }
}