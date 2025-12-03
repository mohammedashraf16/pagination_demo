import 'package:flutter/material.dart';
import 'package:pagination_demo/features/products/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
/*
   Limit            Skip
    20               0   
    20       +       20
    20               40
*/ 
