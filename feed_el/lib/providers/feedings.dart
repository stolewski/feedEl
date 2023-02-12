import 'package:feed_el/db/db_provider.dart';
import 'package:flutter/material.dart';

import '../models/feeding.dart';

class Feedings with ChangeNotifier {
  List<Feeding> _feedings = [];

  List<Feeding> get feedings {
    return [..._feedings];
  }

  addFeeding(TimeOfDay time, String type, String side, int? quantity,
      bool eructated, bool vivomix, bool d3, String date) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final newFeeding = Feeding(
        id: id,
        time: time,
        type: type,
        side: side,
        quantity: quantity,
        eructated: eructated,
        vivomix: vivomix,
        d3: d3,
        date: date);
    _feedings.add(newFeeding);
    notifyListeners();
    Map<String, Object> data = {
      "id": id,
      "time": time.toString().substring(10, 15),
      "type": type,
      "side": side,
      "quantity": quantity ?? 0,
      "d3": d3.toString(),
      "vivomix": vivomix.toString(),
      "eructated": eructated.toString(),
      "date": date
    };
    DBProvider.insertFeeding('feeding', data);
  }

  Future<void> getDayFeedings(String date) async {
    final dataList = await DBProvider.getFeedings('feeding');
    _feedings = dataList
        .map((feeding) => Feeding(
            id: feeding['id'],
            time: TimeOfDay(
                hour: int.parse(feeding['time'].split(":")[0]),
                minute: int.parse(feeding['time'].split(":")[1])),
            type: feeding['type'],
            side: feeding['side'],
            vivomix: feeding['vivomix'] == 'true',
            d3: feeding['d3'] == 'true',
            eructated: feeding['eructated'] == 'true',
            quantity: int.parse(feeding['quantity']),
            date: feeding['date']))
        .where((item) => item.date.split('T').first == date)
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

  bool wasVVmix() {
    return _feedings.any((element) => element.vivomix);
  }

  bool wasD3() {
    return _feedings.any((element) => element.d3);
  }

  void deleteFeeding(int index) {
    final int id = _feedings[index].id;
    _feedings.removeAt(index);
    notifyListeners();
    DBProvider.deleteFeeding(id);
  }
}
