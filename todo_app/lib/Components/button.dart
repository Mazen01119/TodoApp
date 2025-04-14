import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  void Function()? onPressed;
  MyButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 54,
      width: 341,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF409DFA)), foregroundColor: MaterialStateProperty.all(Colors.black)),
        onPressed:onPressed ,
        child: Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),),
        
      
      ),
    );
  }
}