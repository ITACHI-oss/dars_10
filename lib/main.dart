import 'package:dars_10/presentation/screen/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate Tasks',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
