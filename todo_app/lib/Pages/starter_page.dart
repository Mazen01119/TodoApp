import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/Components/button.dart';
import 'package:todo_app/Pages/register_page.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 165,
                width: 185,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('lib/Images/AgendisLogo.png'), fit: BoxFit.cover)),
              ),
              const SizedBox(height: 30,),
              const Text("Agendis - Latin plural for Agendus, meaning which is being done. Welcome to your new favorite ToDo App.", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              const SizedBox(height: 30,),
              MyButton(title: "Get Started", onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
              })
            ],
          ),
        ),
      ),
    );
  }
}