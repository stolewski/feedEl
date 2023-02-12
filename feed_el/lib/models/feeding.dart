import 'package:flutter/material.dart';

class Feeding {
  final int id;
  final TimeOfDay time;
  final String type;
  final String? side;
  final int? quantity;
  final bool eructated;
  final bool vivomix;
  final bool d3;
  final String date;

  Feeding(
      {required this.id,
      required this.time,
      required this.type,
      this.side,
      required this.eructated,
      this.quantity,
      required this.vivomix,
      required this.d3,
      required this.date});
}
