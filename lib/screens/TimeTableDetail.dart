import 'package:flutter/material.dart';

import 'package:home_page/LessonAdd.dart';
import 'package:home_page/bottom.dart';

import 'package:home_page/screens/sisLoginPage.dart';

import 'package:home_page/utilts/services/dbHelper.dart';
import 'package:home_page/utilts/models/lesson.dart';
import 'package:home_page/lessonDetail.dart';
import 'package:home_page/methods.dart';

Methods methods = Methods();

// ignore: must_be_immutable
class Timetabledetail extends StatefulWidget {
  Lesson? lesson;
  Timetabledetail.full(this.lesson, {super.key});
  Timetabledetail();
  @override
  State<Timetabledetail> createState() => _TimetabledetailState();
}

class _TimetabledetailState extends State<Timetabledetail> {
  List<Lesson>? lessons;
  var dbHelper = Dbhelper();

  final List<String> days = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

  @override
  void initState() {
    super.initState();
    getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar2(context, 0), // Alt gezinme çubuğu

      appBar: AppBar(
        title: const Text("Ders Programı"),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == "delete") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Uyarı"),
                      content: const Text(
                          "Dersleri gerçekten silmek istediğinize emin misiniz?"),
                      actions: [
                        TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text("Hayır")),
                        TextButton(
                            onPressed: () {
                              dbHelper.deleteDatabaseFile();
                              Navigator.pop(context);

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Bilgilendirme"),
                                      content: const Text(
                                          "İşleminiz gerçekleştirilmiştir, ekranı yenileyiniz."),
                                      actions: [
                                        TextButton(
                                          child: const Text("Tamam"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text("Evet")),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "delete", child: Text("Dersleri Sil"))
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 39, 113, 148),
          Color.fromARGB(255, 255, 255, 255),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: lessons == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : lessons!.isEmpty
                ? const Center(
                    child: Text(
                      "Henüz ders eklenmedi.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final dailyLessons = lessons!
                          .where((lesson) => lesson.day == day)
                          .toList();

                      return buildDayCard(day, dailyLessons);
                    },
                  ),
      ),
      floatingActionButton: Builder(
        builder: (fabContext) {
          return FloatingActionButton(
            onPressed: () {
              final RenderBox button =
                  fabContext.findRenderObject() as RenderBox;
              final position = button.localToGlobal(Offset(65, -135));
              _showFabMenu(fabContext, position);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.lightBlueAccent,
          );
        },
      ),
    );
  }

  void _showFabMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: const Text('Manuel Ekle'),
            onTap: () {
              goToLessonAdd();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text("Otomatik Al"),
            onTap: () {
              methods.navigateToPage(context, Sisloginpage());
            },
          ),
        ),
      ],
    );
  }

  Widget buildDayCard(String day, List<Lesson> dailyLessons) {
    if (dailyLessons.isEmpty) return const SizedBox();

    dailyLessons.sort(compareLessonsByHour);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dailyLessons.length,
                itemBuilder: (context, index) {
                  final lesson = dailyLessons[index];
                  return buildLessonCard(lesson);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLessonCard(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          goToDetail(lesson);
        },
        child: Card(
          color: const Color.fromARGB(175, 0, 174, 254),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lesson.name ?? "Ders Adı Yok",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lesson.teacher ?? "Öğretmen adı yok",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      lesson.place ?? "Yer Yok",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.hour1 ?? "Saat Yok",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          if (lesson.hour2 != null && lesson.hour2!.isNotEmpty)
                            Text(
                              lesson.hour2!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.remove, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Devamsızlık = ${lesson.attendance}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToLessonAdd() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LessonAdd()),
    );
    if (!mounted) return;
    if (result == true) {
      getLessons();
    }
  }

  void getLessons() async {
    var data = await dbHelper.getLessons();
    if (!mounted) return;
    setState(() {
      lessons = data;
    });
  }

  void goToDetail(Lesson lesson) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LessonDetail(lesson: lesson)),
    );
    if (!mounted) return;

    if (result != null && result == true) {
      getLessons();
    }
  }

  int compareLessonsByHour(Lesson a, Lesson b) {
    String hourA = a.hour1 ?? "00:00";
    String hourB = b.hour1 ?? "00:00";

    return hourA.compareTo(hourB);
  }
}
