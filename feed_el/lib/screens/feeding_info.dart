import 'package:flutter/material.dart';
import 'package:feed_el/models/feeding.dart';

class FeedingInfo extends StatelessWidget {
  static const routeName = '/feedingInfo';
  const FeedingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Feeding feeding =
        ModalRoute.of(context)!.settings.arguments as Feeding;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeding Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Feeding time: ${feeding.time.toString().substring(10, 15)}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Feeding type: ${feeding.type}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          if (feeding.type == 'BF')
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Breast side: ${feeding.side}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          if (feeding.type == 'MM')
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Amount: ${feeding.quantity} ml',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Odbiło się: ${feeding.eructated ? '+' : '-'}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Vivomix:  ${feeding.vivomix ? '+' : '-'}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'D3:  ${feeding.d3 ? '+' : '-'}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }
}
