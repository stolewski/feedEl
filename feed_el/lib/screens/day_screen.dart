import 'package:feed_el/models/feeding.dart';
import 'package:feed_el/screens/main_list.dart';
import 'package:flutter/material.dart';
import 'package:feed_el/screens/add_feeding.dart';
import 'package:feed_el/screens/feeding_info.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:feed_el/providers/feedings.dart';
import 'package:feed_el/utils/date_time_api.dart';

class DayScreen extends StatefulWidget {
  static const routeName = '/dayScreen';
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DateTime today = DateTime.now();
  late List dbData;

  void addFeeding(String date) {
    final DateTime updatedToday = DateTime.now();
    if (updatedToday.toDateString() == date) {
      Navigator.of(context).pushNamed(AddFeeding.routeName);
    } else {
      Navigator.of(context).pushNamed(MainList.routeName);
    }
  }

  String getTitleString(Feeding feeding) {
    if (feeding.type == 'MM') {
      return '${feeding.type} ${feeding.quantity} ml';
    } else if (feeding.type == 'BF') {
      return '${feeding.type} ${feeding.side}';
    } else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date =
        ModalRoute.of(context)!.settings.arguments as DateTime;
    final DateTime today = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMMd().format(date)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamed(MainList.routeName),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Column(
          children: [
            Center(
              child: Text(
                DateFormat.yMMMMd().format(date),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            if (date.toDateString() == today.toDateString())
              Center(
                child: OutlinedButton(
                  child: const Text('Add new feeding'),
                  onPressed: () => addFeeding(date.toDateString()),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                  future: Provider.of<Feedings>(context, listen: false)
                      .getDayFeedings(date.toDateString()),
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
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                            'Vivomix: ${Provider.of<Feedings>(context).wasVVmix() ? '+' : '-'}'),
                                        Text(
                                            'D3: ${Provider.of<Feedings>(context).wasD3() ? '+' : '-'}'),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: feedingsList.feedings.length,
                                        itemBuilder: (context, ind) => ListTile(
                                          title: Text(
                                              '#${ind + 1} ${getTitleString(feedingsList.feedings[ind])}'),
                                          subtitle: Text(
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(feedingsList
                                                      .feedings[ind].time)),
                                          trailing: IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_rounded),
                                            onPressed: () =>
                                                Provider.of<Feedings>(context,
                                                        listen: false)
                                                    .deleteFeeding(ind),
                                          ),
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
