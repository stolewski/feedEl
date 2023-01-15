import 'package:feed_el/db/db_provider.dart';
import 'package:flutter/material.dart';

import '../models/feeding.dart';

class Feedings with ChangeNotifier {
  List<Feeding> _feedings = [];

  List<Feeding> get feedings {
    return [..._feedings];
  }

  addFeeding(TimeOfDay time, String type, String side, int? quantity,
      bool eructated, String note, String date) {
    final newFeeding = Feeding(
        time: time,
        type: type,
        side: side,
        quantity: quantity,
        eructated: eructated,
        note: note,
        date: date);
    _feedings.add(newFeeding);
    notifyListeners();
    Map<String, Object> data = {
      "time": time.toString().substring(10, 15),
      "type": type,
      "side": side,
      "quantity": quantity ?? 0,
      "note": note,
      "eructated": eructated.toString(),
      "date": date
    };
    DBProvider.insertFeeding('feeding', data);
  }

  Future<void> getDayFeedings(String date) async {
    final dataList = await DBProvider.getFeedings('feeding');
    _feedings = dataList
        .map((feeding) => Feeding(
            time: TimeOfDay(
                hour: int.parse(feeding['time'].split(":")[0]),
                minute: int.parse(feeding['time'].split(":")[1])),
            type: feeding['type'],
            side: feeding['side'],
            note: feeding['note'],
            eructated: feeding['eructated'] == 'true',
            quantity: int.parse(feeding['quantity']),
            date: feeding['date']))
        .where((item) => item.date == date)
        .toList();
    notifyListeners();
  }

  String calculateBF() {
    final feedingsBF =
        _feedings.where(((element) => element.type == 'BF')).toList();
    return feedingsBF.length.toString();
  }

  String calculateMMamount() {
    final List<int> result = _feedings
        .where((item) => item.quantity != null)
        .map((item) => item.quantity!)
        .toList();
    return result.isNotEmpty
        ? result.reduce((value, element) => value + element).toString()
        : '-';
  }
}
