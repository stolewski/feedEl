import 'package:feed_el/providers/days.dart';
import 'package:flutter/material.dart';
import 'package:feed_el/screens/day_screen.dart';
import 'package:provider/provider.dart';

class MainList extends StatelessWidget {
  static const routeName = '/';
  const MainList({super.key});

  void addNewDay() {}

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toString().substring(0, 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeding Eliza tracker'),
      ),
      body: FutureBuilder(
          future: Provider.of<Days>(context, listen: false).getDays(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Days>(
                  child: const Center(child: Text('You have no records yet')),
                  builder: (ctx, days, ch) => days.days.isEmpty
                      ? ch!
                      : ListView.builder(
                          itemCount: days.days.length,
                          itemBuilder: (ctx, i) => ListTile(
                                title: Text(days.days[i].date,
                                    textAlign: TextAlign.center),
                                onTap: () => Navigator.of(ctx).pushNamed(
                                    DayScreen.routeName,
                                    arguments: days.days[i].date),
                              )))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(DayScreen.routeName, arguments: today),
        tooltip: 'Add Day',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
