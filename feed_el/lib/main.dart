import 'package:feed_el/providers/days.dart';
import 'package:feed_el/providers/feedings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feed_el/screens/main_list.dart';
import 'package:feed_el/screens/day_screen.dart';
import 'package:feed_el/screens/add_feeding.dart';
import 'package:feed_el/screens/feeding_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Days>(create: (_) => Days()),
        ChangeNotifierProvider<Feedings>(create: (_) => Feedings()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FeedEl',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          MainList.routeName: (ctx) => const MainList(),
          DayScreen.routeName: (ctx) => const DayScreen(),
          AddFeeding.routeName: (ctx) => const AddFeeding(),
          FeedingInfo.routeName: (ctx) => const FeedingInfo(),
        },
      ),
    );
  }
}
