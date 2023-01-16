import 'package:feed_el/db/db_provider.dart';
import 'package:flutter/material.dart';

import '../models/day.dart';
import 'package:feed_el/utils/string_api.dart';

class Days with ChangeNotifier {
  List<Day> _days = [];

  List<Day> get days {
    return [..._days];
  }

  addDay(String date) {
    if (!_days.any((item) => item.date.subDate() == date.subDate())) {
      _days.add(Day(date));
      notifyListeners();
      DBProvider.insertDay('day', {"date": date});
    }
  }

  Future<void> getDays() async {
    final dataList = await DBProvider.getDays('day');
    _days = dataList.map((day) => Day(day['date'])).toList();
    notifyListeners();
  }
}
