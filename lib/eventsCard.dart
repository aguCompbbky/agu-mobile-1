import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_page/bottom.dart';
import 'package:home_page/utilts/models/events.dart';
import 'package:home_page/utilts/services/apiService.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsCard extends StatefulWidget {
  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  final EventsApi eventsApi = EventsApi();
  late List<Events> _eventList = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Veriyi burada bir kere çekiyoruz
    _loadData();
    _startAutoSlide();
  }

  // Veriyi yükleyen fonksiyon
  Future<void> _loadData() async {
    try {
      List<Events> events = await eventsApi.fetchEventsData();
      setState(() {
        _eventList = events; // Listeyi güncelliyoruz
      });
    } catch (e) {
      // Hata durumunda gerekli işlemleri yapabilirsiniz
      print("Error loading data: $e");
    }
  }

  // Otomatik sayfa kaydırma işlemi
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_eventList.isNotEmpty) {
        setState(() {
          _currentPage = (_currentPage + 1) % _eventList.length;
        });

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          height: screenHeight * 0.25, // Yükseklik ekranın %25'i
          width: screenWidth * 0.85, // Genişlik ekranın %85'i
          child: _eventList.isEmpty
              ? Center(
                  child:
                      CircularProgressIndicator()) // Veri yüklenene kadar gösterilecek widget
              : Stack(
                  children: [
                    // PageView ile fotoğraflar arasında kaydırma
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _eventList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        var event = _eventList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailPage(event: event),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.transparent,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                event.uygulama_ici_resim!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Dots Gösterge (Sayfa göstergeleri)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_eventList.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

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
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        //color: const Color.fromARGB(163, 99, 95, 95),

                        borderRadius:
                            BorderRadius.circular(12), // Kenar yuvarlama
                      ),
                      padding: const EdgeInsets.all(
                          8), // Padding ekleyerek metnin etrafına boşluk ekliyoruz
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Card'ın kenarlarını yuvarlıyoruz
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(2.0), // Card içi padding
                          child: Text(
                            "${event.kulup}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    //const SizedBox(width: 20),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Image.asset(
                          "assets/images/calendars/4.png",
                          width: 150,
                          height: 150,
                        ),
                        Text("\n\nTarih\n${formatDate(event.etkinlik_tarihi)}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                    decoration: BoxDecoration(
                      //color: const Color.fromARGB(255, 7, 64, 170),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(8)),
                    ),
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
                  decoration: BoxDecoration(
                    //color: const Color.fromARGB(255, 7, 64, 170),
                    borderRadius: BorderRadius.circular(12), // Kenar yuvarlama
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Expanded ekliyoruz
                      Expanded(
                        child: Text(
                          "${event.etkinlik_aciklamasi}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // gradient: const LinearGradient(
                    //     colors: [Colors.white, Colors.red, Colors.white],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(12), // Kenar yuvarlama
                  ),
                  padding: const EdgeInsets.all(8),
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
                      // gradient: const LinearGradient(
                      //     colors: [Colors.white, Colors.red, Colors.white],
                      //     begin: Alignment.topLeft,
                      //     end: Alignment.bottomRight),
                      borderRadius:
                          BorderRadius.circular(12), // Kenar yuvarlama
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(event.etkinlik_afisi!,
                        fit: BoxFit.fill, width: double.infinity),
                  ),
                SizedBox(
                  height: 25,
                ),
                const Text("İletişim: ",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                      SizedBox(width: 15),
                      Text(
                        event.sorumlu_iletisim ?? "",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
