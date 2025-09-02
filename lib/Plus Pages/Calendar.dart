import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Home.dart';


class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Map<String, String>>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedDay = _focusedDay;
    _fetchAndGenerateEvents();
  }

  Future<void> _fetchAndGenerateEvents() async {
    _events.clear();
    DateTime today = DateTime.now();

    final snapshot =
    await FirebaseFirestore.instance.collection('plants').get();

    for (var doc in snapshot.docs) {
      final name = doc['label'];
      final iconPath = doc['iconPath'];
      final freq = doc['wateringFrequency'];

      print("📥 $name | $iconPath | $freq");

      if (name == null || iconPath == null || freq == null || freq == 0) continue;

      double interval = 7 / freq;
      int step = interval.round();

      for (int i = 0; i < 30; i += step) {
        DateTime date =
        DateTime(today.year, today.month, today.day).add(Duration(days: i));
        DateTime key = DateTime(date.year, date.month, date.day);
        _events[key] ??= [];
        _events[key]!.add({
          'label': '$name - 💧 تذكير بالسقاية ',
          'iconPath': iconPath,
        });
      }
    }

    setState(() {});
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    DateTime normalized = DateTime(day.year, day.month, day.day);
    return _events[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        title: Text('التقويم الزراعي', style: TextStyle(
            fontFamily: 'PlaypenSansArabic',
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Colors.white),),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.today,color: Colors.white),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ar',
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.map((event) {
                    if (event is Map<String, String> &&
                        event['iconPath'] != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Image.asset(
                          event['iconPath']!,
                          width: 18,
                          height: 18,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }).toList(),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: _selectedDay == null ||
                  _getEventsForDay(_selectedDay!).isEmpty
                  ? Center(
                child: Text('لا يوجد نباتات لهذا اليوم',
                    style: TextStyle(fontFamily: 'PlaypenSansArabic')),
              )
                  : ListView.builder(
                itemCount: _getEventsForDay(_selectedDay!).length,
                itemBuilder: (context, index) {
                  final event = _getEventsForDay(_selectedDay!)[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 22),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          event['iconPath']!,
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event['label']!,
                            style: TextStyle(fontFamily: 'PlaypenSansArabic'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
