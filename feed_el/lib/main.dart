import 'package:flutter/material.dart';
import 'package:feed_el/screens/main_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FeedEl',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainList('Feeding Eliza Tracker'),
    );
  }
}
