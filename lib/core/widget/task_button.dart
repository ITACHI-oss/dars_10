import 'package:flutter/material.dart';

class TaskButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const TaskButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 70),
          backgroundColor: Colors.black,
          side: BorderSide(color: Colors.green),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.green,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
