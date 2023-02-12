import 'package:feed_el/models/day.dart';
import 'package:feed_el/screens/day_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Months extends StatefulWidget {
  final List<Day> days;
  const Months(this.days, {key}) : super(key: key);

  @override
  State<Months> createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  final Map<String, bool> _openMonth = {
    'january': false,
    'february': false,
    'march': false,
    'april': false
  };
  final List<Day> _january = [];
  final List<Day> _february = [];
  final List<Day> _march = [];
  final List<Day> _april = [];

  void sortDaysByMonths(days) {
    for (var item in days) {
      DateTime d = DateTime.parse(item.date);
      switch (d.month) {
        case 1:
          _january.add(item);
          break;
        case 2:
          _february.add(item);
          break;
        case 3:
          _march.add(item);
          break;
        case 4:
          _april.add(item);
          break;
      }
    }
  }

  Widget _buildDaysList(List<Day> month) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: month.length,
      itemBuilder: ((context, index) {
        final DateTime date = DateTime.parse(month[index].date);
        return ListTile(
          tileColor: Colors.grey[200],
          leading: const Icon(Icons.list_alt_sharp),
          title: Text(DateFormat.yMMMMd().format(date)),
          onTap: () => Navigator.of(context)
              .pushNamed(DayScreen.routeName, arguments: date),
        );
      }),
    );
  }

  void _changeOpenedMonth(String month) {
    setState(() {
      _openMonth[month] = !_openMonth[month]!;
    });
  }

  Widget _buildMonth(String month) {
    return TextButton(
        onPressed: () => _changeOpenedMonth(month),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(month, style: const TextStyle(fontSize: 20)),
            Icon(
              _openMonth[month]!
                  ? Icons.arrow_drop_up_sharp
                  : Icons.arrow_drop_down_sharp,
              color: Colors.teal,
            ),
          ],
        ));
  }

  void _selectMonthNow(int month) {
    late String monthString;
    switch (month) {
      case 1:
        monthString = 'january';
        break;
      case 2:
        monthString = 'february';
        break;
      case 3:
        monthString = 'march';
        break;
      case 4:
        monthString = 'april';
        break;
    }
    setState(() {
      _openMonth[monthString] = true;
    });
  }

  @override
  void initState() {
    sortDaysByMonths(widget.days);
    int monthNow = DateTime.now().month;
    _selectMonthNow(monthNow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 25,
          ),
          if (_january.isNotEmpty) _buildMonth('january'),
          if (_openMonth['january']!) _buildDaysList(_january),
          if (_february.isNotEmpty) _buildMonth('february'),
          if (_openMonth['february']!) _buildDaysList(_february),
          if (_march.isNotEmpty) _buildMonth('march'),
          if (_openMonth['march']!) _buildDaysList(_march),
          if (_april.isNotEmpty) _buildMonth('april'),
          if (_openMonth['april']!) _buildDaysList(_april),
        ],
      ),
    );
  }
}
