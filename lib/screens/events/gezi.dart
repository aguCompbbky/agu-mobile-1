import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_page/bottom.dart';
import 'package:home_page/utilts/models/events.dart';

class GeziPage extends StatelessWidget {
  final Trip trip;
  GeziPage({super.key, required this.trip});

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
            child: Text(
                "Etkinlik adı: ${trip.etkinlik_adi} \nSaat: ${trip.saat1} \nKonum: ${trip.konum1} \nAçıklama: ${trip.aciklama1} \netkinlik adı:  ${trip.etkinlik_adi}"),
          ),
        ));
  }
}
