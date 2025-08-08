import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_page/bottom.dart';
import 'package:home_page/utilts/models/events.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatelessWidget {
  final Events event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Tarih Bilinmiyor";

    try {
      // Tarih verisini alıyoruz, örneğin: 2025-03-28T21:00:00.000Z
      String cleanDate = dateString.split("T")[0]; // "2025-03-28"

      // Tarih parçalarını ayırıyoruz
      List<String> parts = cleanDate.split("-"); // ["2025", "03", "28"]

      // İstediğimiz formatı oluşturuyoruz: "28.03.2025"
      String formattedDate = "${parts[2]}.${parts[1]}.${parts[0]}";

      return formattedDate; // "28.03.2025"
    } catch (e) {
      return "Geçersiz Tarih"; // Eğer format hatası olursa
    }
  }

  void openInstagram(String username) async {
    // Instagram uygulaması için URL
    final Uri url = Uri.parse('instagram://user?username=$username');

    // Web tarayıcı URL'si
    final Uri webUrl = Uri.parse('https://www.instagram.com/$username/');

    // Instagram uygulamasına yönlendirme
    if (await canLaunchUrl(url)) {
      await launchUrl(url); // Eğer uygulama varsa, uygulama ile açılır
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl); // Uygulama yoksa, web tarayıcısında açılır
    } else {
      throw 'Instagram hesabı açılamadı';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar2(context, 2), // Alt gezinme çubuğu

      appBar: AppBar(
        title: Text(
          event.etkinlik_adi ?? "ETKİNLİK DETAYLARI",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 39, 113, 148),
            Color.fromARGB(255, 255, 255, 255),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment(1.0, -0.1),
                  children: [
                    Transform.translate(
                      offset: Offset(-65, 0),
                      child: Container(
                        // width: 250,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(12), // Kenar yuvarlama
                          // color: Colors.amber
                        ),
                        padding: const EdgeInsets.all(
                            8), // Padding ekleyerek metnin etrafına boşluk ekliyoruz
                        child: Stack(
                          alignment: Alignment(0.30, 0.001),
                          children: [
                            Image.asset(
                              "assets/images/calendars/tabela6.png",
                              alignment: Alignment.topLeft,
                              height: 350,
                              width: 350,
                            ),
                            Container(
                              // color: Colors.blue,
                              width: 150,
                              height: 100,
                              child: Text(
                                "${event.kulup}",
                                textAlign: TextAlign.left,
                                // overflow: TextOverflow.visible,
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      // alignment: Alignment.topCenter,
                      alignment: Alignment(0.25, 0.5),
                      children: [
                        Image.asset(
                          "assets/images/calendars/4.png",
                          width: 100,
                          height: 100,
                        ),
                        Text("Tarih\n${formatDate(event.etkinlik_tarihi)}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Transform.translate(
                  offset: const Offset(0, 10), // 10 piksel aşağı kaydır
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(8),
                            // bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        border: Border(
                            bottom: BorderSide(width: 6.0, color: Colors.white),
                            right:
                                BorderSide(width: 3.0, color: Colors.white))),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Etkinlik Detayları: ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      border: Border(
                          bottom: BorderSide(width: 6.0),
                          right: BorderSide(width: 5.0))),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Expanded ekliyoruz
                      Expanded(
                        child: Text(
                          "${event.etkinlik_aciklamasi}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          // overflow:
                          //     TextOverflow.ellipsis, // Taşmayı engellemek için
                          softWrap:
                              true, // Uzun metinlerde satır kayması yapacak
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.uygulama_ici_resim ?? "",
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 20),
                if (event.etkinlik_afisi != null &&
                    event.etkinlik_afisi!.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(event.etkinlik_afisi!,
                        fit: BoxFit.fill, width: double.infinity),
                  ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  spacing: 120,
                  children: [
                    Column(
                      children: [
                        const Text("İletişim: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            openInstagram(event.sorumlu_iletisim ?? "");
                          }, // Burada mail göndermek için bir işlem ekleyebilirsin
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.network(
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/640px-Instagram_icon.png",
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                event.sorumlu_iletisim ?? "",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.amber;
                              // Theme.of(context)
                              //     .colorScheme
                              //     .primary
                              //     .withOpacity(0.5);
                            }
                            return Colors
                                .blueAccent; // Use the component's default.
                          },
                        ),
                      ),
                      child: const Text('Hemen katıl',
                          style: TextStyle.new(color: Colors.white)),
                      onPressed: () {
                        // ...
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
