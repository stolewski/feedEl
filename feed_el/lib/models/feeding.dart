import 'package:flutter/material.dart';

class Feeding {
  final TimeOfDay time;
  final String type;
  final String? side;
  final int? quantity;
  final bool eructated;
  final String note;
  final String date;

  Feeding(
      {required this.time,
      required this.type,
      this.side,
      required this.eructated,
      this.quantity,
      required this.note,
      required this.date});
}
