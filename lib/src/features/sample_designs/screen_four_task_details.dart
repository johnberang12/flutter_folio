import 'package:flutter/material.dart';

class ScreenFourTaskDetails extends StatelessWidget {
  const ScreenFourTaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[50],
          leading: Icon(Icons.arrow_back, color: Colors.grey[800])),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Wireframing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            MapContent(contentKey: 'Type', value: 'Work'),
            MapContent(contentKey: 'Priority', value: 'Needs Done'),
            MapContent(contentKey: 'Timeframe', value: '3 days'),
            MapContent(
                contentKey: 'Description',
                value:
                    'The purpose of this project is to design a user-friendly and intuitive wireframing to do list application that allows users to create, manage, and track their tasks efficiently')
          ],
        ),
      ),
    ));
  }
}

class MapContent extends StatelessWidget {
  const MapContent({super.key, required this.contentKey, required this.value});
  final String contentKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: '$contentKey: ',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: value),
      ])),
    );
  }
}
