import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/boxes.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Data/goal.dart';
import 'package:todo_app/Data/task.dart';
import 'package:todo_app/Pages/home_page.dart';
import 'package:todo_app/Pages/my_init.dart';
import 'package:todo_app/Pages/starter_page.dart';
import 'package:todo_app/Pages/test_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(TaskAdapter());
  goalBox = await Hive.openBox<Goal>('goalBox');
  person = await Hive.openBox('Person');
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyInitGate(),
    );
  }
}

