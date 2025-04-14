import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  MyTextField({super.key, required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: controller,
      decoration: InputDecoration(
       border: OutlineInputBorder(),
       labelText: labelText,

      ),
      

    );
  }
}