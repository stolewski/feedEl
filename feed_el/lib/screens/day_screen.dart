import 'package:flutter/material.dart';
import 'package:feed_el/screens/add_feeding.dart';
import 'package:feed_el/screens/feeding_info.dart';
import 'package:provider/provider.dart';
import 'package:feed_el/providers/feedings.dart';

class DayScreen extends StatefulWidget {
  static const routeName = '/dayScreen';
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DateTime today = DateTime.now();
  late List dbData;

  @override
  Widget build(BuildContext context) {
    final String date = ModalRoute.of(context)!.settings.arguments as String;
    final String today = DateTime.now().toString().substring(0, 10);
    return Scaffold(
      appBar: AppBar(
        title: Text(date),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Column(
          children: [
            Center(
              child: Text(
                date,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            if (date == today)
              Center(
                child: OutlinedButton(
                  child: const Text('Add new feeding'),
                  onPressed: () => Navigator.of(context).pushNamed(
                      AddFeeding.routeName,
                      arguments: DateTime.now()),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                  future: Provider.of<Feedings>(context, listen: false)
                      .getDayFeedings(date),
                  builder: ((context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Consumer<Feedings>(
                          child: const Center(
                              child: Text('No feedings added today yet')),
                          builder: (ctx, feedingsList, ch) => feedingsList
                                  .feedings.isEmpty
                              ? ch!
                              : Column(
                                  children: [
                                    Text(
                                        'Total feedings: ${feedingsList.feedings.length}'),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'BF: ${Provider.of<Feedings>(context).calculateBF()}'),
                                        Text(
                                            'MM: ${feedingsList.feedings.length - int.parse(Provider.of<Feedings>(context).calculateBF())}'),
                                        Text(
                                            'Total MM amount: ${Provider.of<Feedings>(context).calculateMMamount()} ml'),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: feedingsList.feedings.length,
                                        itemBuilder: (context, ind) => ListTile(
                                          title: Text(
                                              '#${ind + 1} Feeding ${feedingsList.feedings[ind].type}'),
                                          subtitle: Text(
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(feedingsList
                                                      .feedings[ind].time)),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                FeedingInfo.routeName,
                                                arguments:
                                                    feedingsList.feedings[ind]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )))),
            ),
          ],
        ),
      ),
    );
  }
}
