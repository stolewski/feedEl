import 'package:feed_el/providers/days.dart';
import 'package:feed_el/providers/feedings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FeedingType { breast, bottle }

enum Side { left, right, both }

class AddFeeding extends StatefulWidget {
  static const routeName = '/addFeeding';
  const AddFeeding({super.key});

  @override
  State<AddFeeding> createState() => _AddFeedingState();
}

class _AddFeedingState extends State<AddFeeding> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();
  TimeOfDay _feedingTime = TimeOfDay.now();
  FeedingType? _feedingType;
  Side? _side;
  bool? _isEructated = false;
  bool _isVivomix = false;
  bool _isD3 = false;

  @override
  void dispose() {
    _noteController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  _changeFeedingTime() async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: _feedingTime);

    if (pickedTime != null && pickedTime != _feedingTime) {
      setState(() {
        _feedingTime = pickedTime;
      });
    }
  }

  _saveFeeding() {
    final side = _side == Side.both
        ? 'both'
        : _side == Side.left
            ? 'left'
            : 'right';
    final type = _feedingType == FeedingType.bottle ? 'MM' : 'BF';
    final quantity = _quantityController.text.isEmpty
        ? null
        : int.parse(_quantityController.text);
    final today = DateTime.now().toIso8601String();
    Provider.of<Feedings>(context, listen: false).addFeeding(_feedingTime, type,
        side, quantity, _isEructated!, _isVivomix, _isD3, today);

    Provider.of<Days>(context, listen: false).addDay(today);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Feeding'),
          actions: [
            TextButton(
                onPressed: () => _saveFeeding(),
                child:
                    const Text('SAVE', style: TextStyle(color: Colors.white)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 35),
                    child: Column(
                      children: [
                        Text(
                          MaterialLocalizations.of(context)
                              .formatTimeOfDay(_feedingTime),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: _changeFeedingTime,
                          child: const Text('Change feeding Time'),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Choose Feeding Type:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: RadioListTile<FeedingType>(
                              value: FeedingType.breast,
                              title: const Text('Breast'),
                              groupValue: _feedingType,
                              onChanged: ((FeedingType? value) {
                                setState(() {
                                  _feedingType = value;
                                });
                              }),
                            )),
                            Expanded(
                                child: RadioListTile<FeedingType>(
                              value: FeedingType.bottle,
                              title: const Text('Bottle'),
                              groupValue: _feedingType,
                              onChanged: ((FeedingType? value) {
                                setState(() {
                                  _feedingType = value;
                                });
                              }),
                            )),
                          ],
                        ),
                        if (_feedingType == FeedingType.breast)
                          Column(
                            children: [
                              const Text('Choose side:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<Side>(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: Side.left,
                                      title: const Text('Left'),
                                      groupValue: _side,
                                      onChanged: ((Side? value) {
                                        setState(() {
                                          _side = value;
                                        });
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<Side>(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: Side.right,
                                      title: const Text('Right'),
                                      groupValue: _side,
                                      onChanged: ((Side? value) {
                                        setState(() {
                                          _side = value;
                                        });
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<Side>(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: Side.both,
                                      title: const Text('Both'),
                                      groupValue: _side,
                                      onChanged: ((Side? value) {
                                        setState(() {
                                          _side = value;
                                        });
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (_feedingType == FeedingType.bottle)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Quantity:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: 70,
                                  height: 30,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.none,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: _quantityController,
                                    validator: ((value) {
                                      return (value == null || value.isEmpty)
                                          ? 'Please enter amount'
                                          : null;
                                    }),
                                  )),
                              const Text('ml'),
                            ],
                          ),
                        Row(
                          children: [
                            Checkbox(
                                value: _isEructated,
                                onChanged: (bool? value) => setState(() {
                                      _isEructated = value;
                                    })),
                            const Text('Odbiło się'),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Checkbox(
                                value: _isVivomix,
                                onChanged: (bool? value) => setState(() {
                                      _isVivomix = value!;
                                    })),
                            const Text('Vivomix'),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Checkbox(
                                value: _isD3,
                                onChanged: (bool? value) => setState(() {
                                      _isD3 = value!;
                                    })),
                            const Text('D3'),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
