import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_page/bottom.dart';
import 'package:home_page/utilts/constants/constants.dart';
import 'package:home_page/utilts/models/events.dart';
import 'package:home_page/utilts/services/apiService.dart';

class ConferencePage extends StatelessWidget {
  final Speaker speaker;

  ConferencePage({super.key, required this.speaker});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: bottomBar2(context, 2),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Ünvan: ${speaker.unvan1}\nAd: ${speaker.ad1}\n Foto url: ${speaker.url1}"),
          ),
        ),
      ),
    );
  }
}
