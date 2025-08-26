import 'package:flutter/material.dart';
import 'package:home_page/utilts/services/dbHelper.dart';
import 'package:home_page/utilts/models/lesson.dart';

class LessonAdd extends StatefulWidget {
  @override
  State<LessonAdd> createState() => _LessonAdd();
}

class _LessonAdd extends State<LessonAdd> {
  String? selectedHour1;
  String? selectedHour2;
  String? selectedDay;
  var dbHelper = Dbhelper();

  TextEditingController txtName = TextEditingController();
  TextEditingController txtClass = TextEditingController();
  TextEditingController txtTeacher = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ders Ekleme"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ders Bilgileri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            buildNameField(),
            const SizedBox(height: 10),
            buildClassField(),
            const SizedBox(height: 20),
            const Text(
              "Öğretmen Bilgileri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            buildTeacherField(),
            const SizedBox(height: 20),
            const Text(
              "Ders Günü ve Saatleri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            buildDayField(),
            const SizedBox(height: 10),
            buildHour1Field(),
            const SizedBox(height: 10),
            buildHour2Field(),
            const SizedBox(height: 30),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Ders Adı",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.book),
      ),
      controller: txtName,
    );
  }

  Widget buildClassField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Sınıf",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.place),
      ),
      controller: txtClass,
    );
  }

  Widget buildTeacherField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Öğretmen Adı",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.person),
      ),
      controller: txtTeacher,
    );
  }

  Widget buildDayField() {
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
        labelText: "Gün Seç",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.calendar_today),
      ),
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

  Widget buildHourField(
      String label, String? selectedHour, void Function(String?) onChanged) {
    final List<String> hours = [
      "08:00-08:45",
      "09:00-09:45",
      "10:00-10:45",
      "11:00-11:45",
      "12:00-12:45",
      "13:00-13:45",
      "14:00-14:45",
      "15:00-15:45",
      "16:00-16:45",
      "17:00-17:45",
      "18:00-18:45",
      "19:00-19:45",
    ];

    return DropdownButtonFormField<String>(
      value: selectedHour,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.access_time),
      ),
      items: hours
          .map((hour) => DropdownMenuItem(
                value: hour,
                child: Text(hour),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget buildHour1Field() {
    return buildHourField("İlk Ders Saatinizi Giriniz", selectedHour1, (value) {
      setState(() {
        selectedHour1 = value;
      });
    });
  }

  Widget buildHour2Field() {
    return buildHourField("İkinci Ders Saatinizi Giriniz", selectedHour2,
        (value) {
      setState(() {
        selectedHour2 = value;
      });
    });
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: addLesson,
        icon: const Icon(Icons.save),
        label: const Text("Ders Ekle"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  void addLesson() async {
    if (txtName.text.isEmpty ||
        txtClass.text.isEmpty ||
        selectedDay == null ||
        selectedHour1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
      );
      return;
    }

    await dbHelper.insert(
      Lesson(txtName.text, txtClass.text, selectedDay, selectedHour1,
          selectedHour2, txtTeacher.text),
    );
    Navigator.pop(
        context, true); // Ders başarıyla eklendiğinde önceki sayfaya dön
  }
}
