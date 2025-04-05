import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Pages/home_page.dart';
import 'package:todo_app/Pages/starter_page.dart';

class MyInitGate extends StatefulWidget {
  const MyInitGate({super.key});

  @override
  State<MyInitGate> createState() => _MyInitGateState();
}

class _MyInitGateState extends State<MyInitGate> {
bool isFirstLaunch = false;
bool isLoading = true;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInitialization();
  }

  Future<void> _checkInitialization() async {

 


    person = await Hive.openBox('Person');
    isFirstLaunch = person.get('firstLaunch', defaultValue: true) as bool;
    print(isFirstLaunch);
setState(() {
  isLoading = false;
});
    if(isFirstLaunch) {
      person.put('firstLaunch', false);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    print(isFirstLaunch);
    return isLoading? Container() : isFirstLaunch ? StarterPage() : HomePage();
  }
}