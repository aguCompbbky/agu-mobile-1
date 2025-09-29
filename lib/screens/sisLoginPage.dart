import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_page/methods.dart';
import 'package:home_page/notifications.dart';
import 'package:home_page/screens/TimeTableDetail.dart';
import 'package:home_page/utilts/models/lesson.dart';
// import 'package:home_page/data/lesson.dart';
import 'package:home_page/utilts/services/dbHelper.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Methods methods = Methods();
Dbhelper dbhelper = Dbhelper();

class Sisloginpage extends StatefulWidget {
  const Sisloginpage({super.key});

  @override
  State<Sisloginpage> createState() => _SisloginpageState();
}

class _SisloginpageState extends State<Sisloginpage> {
  Uint8List? captchaImage;
  String? sessionId;
  bool? isLessonLoading = false;

  TextEditingController? studentNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? captchaController = TextEditingController();

  IOClient? ioClient;

  @override
  void initState() {
    super.initState();
    fetchCaptcha();

    // SSL bypass için HttpClient oluştur
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    ioClient = IOClient(client);
  }

  Future<void> fetchCaptcha() async {
    final response = await http.get(Uri.parse(
        "https://agumobilefastapiupdated-cpbadkf9e5hrgmgp.westeurope-01.azurewebsites.net/get-captcha"));

    if (response.statusCode == 200) {
      setState(() {
        sessionId = response.headers["x-session-id"];
        captchaImage = response.bodyBytes;
      });
    } else {
      printColored("Captcha alınamadı : ${response.statusCode}", "31");
    }
  }

  Future<void> loginSIS() async {
    if (sessionId == null) return;

    setState(() {
      isLessonLoading = true;
    });

    final Map<String, String> dayMap = {
      "grd0": "Pazartesi",
      "grd1": "Salı",
      "grd2": "Çarşamba",
      "grd3": "Perşembe",
      "grd4": "Cuma",
    };

    final response = await ioClient!.post(
      Uri.parse(
          "https://agumobilefastapiupdated-cpbadkf9e5hrgmgp.westeurope-01.azurewebsites.net/start-login"),
      body: {
        "session_id": sessionId!,
        "username": studentNumberController!.text,
        "password": passwordController!.text,
        "captcha": captchaController!.text,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Login başarısız: ${response.statusCode}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data["ok"] != true) {
      throw Exception("Login cevabı OK değil");
    }

    final Map<String, Map<String, dynamic>> grouped = {};
    final tables = data["data"] as Map<String, dynamic>;

    tables.forEach((key, value) {
      final dayName = dayMap[key] ?? "Bilinmeyen Gün";
      final tableList = value as List;

      for (var row in tableList) {
        if (row is List && row.length >= 5) {
          final hour = row[0];
          final section = row[1];
          final lesson = row[2];
          final place = row[3];
          final teacher = row[4];

          final groupKey = "$dayName-$lesson-$teacher";

          if (!grouped.containsKey(groupKey)) {
            grouped[groupKey] = {
              "lesson": lesson,
              "section": section,
              "teacher": teacher,
              "place": place,
              "day": dayName,
              "hours": []
            };
          }

          grouped[groupKey]!["hours"].add(hour);
        }
      }
    });

    for (var entry in grouped.values) {
      final hours = entry["hours"] as List;

      String? hour1;
      String? hour2;

      if (hours.isNotEmpty) {
        hour1 = hours[0];
      }
      if (hours.length > 1) {
        hour2 = hours[1];
      }

      await dbhelper.insert(
        Lesson(
          entry["lesson"],
          entry["place"],
          entry["day"],
          hour1,
          hour2,
          entry["teacher"],
        ),
      );
    }

    setState(() {
      isLessonLoading = false;
    });

    printColored("Login cevabı ${response.body}: ", "31");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otomatik Ders Yükleme"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SIS Bilgileri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              methods.buildTextField("Öğrenci Numaranız",
                  const Icon(Icons.email), studentNumberController!),
              const SizedBox(height: 20),
              methods.buildPasswordField(
                  "Şifreniz", const Icon(Icons.lock), passwordController!),
              const SizedBox(height: 20),
              Row(
                children: [
                  captchaImage != null
                      ? Image.memory(
                          captchaImage!,
                          height: 50,
                          width: 150,
                        )
                      : const SizedBox(
                          height: 50,
                          width: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 214.4,
                    child: methods.buildTextField("Sayıların Toplamı",
                        const Icon(Icons.add_box_rounded), captchaController!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    await loginSIS();

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Timetabledetail()),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Hata: $e")),
                    );
                  }
                },
                child: const Text("Gönder"),
              ),
            ]),
      ),
    );
  }
}
