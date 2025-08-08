import 'package:flutter/material.dart';
import 'package:home_page/utilts/services/dbHelper.dart';
import 'package:home_page/utilts/models/lesson.dart';

class LessonDetail extends StatefulWidget {
  final Lesson lesson; // Seçilen ders

  LessonDetail({required this.lesson});

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  var dbHelper = Dbhelper();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtClass = TextEditingController();
  String? selectedDay;
  String? selectedHour1;
  String? selectedHour2;
  String? selectedHour3;

  @override
  void initState() {
    super.initState();
    // Mevcut ders bilgilerini forma doldur
    txtName.text = widget.lesson.name ?? '';
    txtClass.text = widget.lesson.place ?? '';
    selectedDay = widget.lesson.day;
    selectedHour1 = widget.lesson.hour1;
    selectedHour2 = widget.lesson.hour2;
    selectedHour3 = widget.lesson.hour3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Detayı"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: deleteLesson,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            tooltip: "Dersi Sil",
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          buildSectionTitle("Ders Bilgileri"),
          SizedBox(height: 15),
          buildInfoCard("Ders Adı", buildNameField()),
          SizedBox(height: 10),
          buildInfoCard("Sınıf", buildClassField()),
          SizedBox(height: 20),
          buildSectionTitle("Ders Günü"),
          SizedBox(height: 15),
          buildInfoCard("Gün Seçimi", buildDayField()),
          SizedBox(height: 10),
          buildSectionTitle("Ders Saatleri"),
          SizedBox(
            height: 15,
          ),
          buildInfoCard("Birinci Ders Saati", buildHour1Field()),
          buildInfoCard("İkinci Ders Saati", buildHour2Field()),
          buildInfoCard("Üçüncü Ders Saati", buildHour3Field()),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildSaveButton(),
              buildDeleteButton(),
            ],
          )
        ],
      ),
    );
  }

  buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
    );
  }

  buildInfoCard(String title, Widget content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  buildNameField() {
    return TextField(
      decoration: InputDecoration(
          hintText: "Ders Adını Giriniz",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      controller: txtName,
    );
  }

  buildClassField() {
    return TextField(
      decoration: InputDecoration(
          hintText: "Sınıf",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      controller: txtClass,
    );
  }

  buildDayField() {
    final List<String> days = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    return DropdownButtonFormField<String>(
      value: selectedDay,
      decoration: InputDecoration(
          hintText: "Gün Seç",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: days
          .map((day) => DropdownMenuItem(
                value: day,
                child: Text(day),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedDay = value;
        });
      },
    );
  }

  buildHour1Field() {
    final List<String> hours = [
      "08.00 - 08.45",
      "09.00 - 09.45",
      "10.00 - 10.45",
      "11.00 - 11.45",
      "12.00 - 12.45",
      "13.00 - 13.45",
      "14.00 - 14.45",
      "15.00 - 15.45",
      "16.00 - 16.45",
      "17.00 - 17.45",
      "18.00 - 18.45",
      "19.00 - 19.45",
      "20.00 - 20.45",
    ];

    return DropdownButtonFormField<String>(
      value: selectedHour1,
      decoration: InputDecoration(
          hintText: "İlk Ders Saati",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: hours
          .map((hour) => DropdownMenuItem(
                value: hour,
                child: Text(hour),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedHour1 = value;
        });
      },
    );
  }

  buildHour2Field() {
    final List<String> hours = [
      "08.00 - 08.45",
      "09.00 - 09.45",
      "10.00 - 10.45",
      "11.00 - 11.45",
      "12.00 - 12.45",
      "13.00 - 13.45",
      "14.00 - 14.45",
      "15.00 - 15.45",
      "16.00 - 16.45",
      "17.00 - 17.45",
      "18.00 - 18.45",
      "19.00 - 19.45",
    ];

    return SingleChildScrollView(
      child: DropdownButtonFormField<String>(
          value: selectedHour2,
          decoration: InputDecoration(
              hintText: "İkinci Ders Saatinizi Giriniz",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: hours
              .map((hour) => DropdownMenuItem(
                    value: hour,
                    child: Text(hour),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedHour2 = value;
            });
          }),
    );
  }

  buildHour3Field() {
    final List<String> hours = [
      "08.00 - 08.45",
      "09.00 - 09.45",
      "10.00 - 10.45",
      "11.00 - 11.45",
      "12.00 - 12.45",
      "13.00 - 13.45",
      "14.00 - 14.45",
      "15.00 - 15.45",
      "16.00 - 16.45",
      "17.00 - 17.45",
      "18.00 - 18.45",
      "19.00 - 19.45"
    ];

    return SingleChildScrollView(
      child: DropdownButtonFormField<String>(
          value: selectedHour3,
          decoration: InputDecoration(
              hintText: "Üçüncü Ders Saatinizi Giriniz",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: hours
              .map((hour) => DropdownMenuItem(
                    value: hour,
                    child: Text(hour),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedHour3 = value;
            });
          }),
    );
  }

  buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: updateLesson,
      icon: Icon(Icons.save, size: 20),
      label: Text("Dersi Güncelle"),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }

  buildDeleteButton() {
    return ElevatedButton.icon(
      onPressed: deleteLesson,
      label: Text("Dersi Sil"),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }

  void updateLesson() async {
    if (txtName.text.isEmpty ||
        txtClass.text.isEmpty ||
        selectedDay == null ||
        selectedHour1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
      );
      return;
    }

    await dbHelper.update(
      Lesson.withID(
        widget.lesson.id,
        txtName.text,
        txtClass.text,
        selectedDay,
        selectedHour1,
        selectedHour2,
        selectedHour3,
      ),
    );
    Navigator.pop(context, true);
  }

  void deleteLesson() async {
    await dbHelper.delete(widget.lesson.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ders başarıyla silindi!")),
    );
    Navigator.pop(context, true);
  }
}
