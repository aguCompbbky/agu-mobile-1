import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_page/Feedbacks.dart';
import 'package:home_page/screens/guide_page.dart';
import 'package:home_page/screens/sisAddLessonsPage.dart';
import 'package:home_page/screens/sisWeeklyProgram.dart';
import 'package:home_page/utilts/models/academic.dart';
import 'package:home_page/utilts/services/apiService.dart';
import 'package:home_page/utilts/services/dbHelper.dart';
import 'package:home_page/utilts/models/lesson.dart';
import 'package:home_page/methods.dart';
import 'package:intl/intl.dart';
import 'package:home_page/notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';

Methods methods = Methods();

class MenuItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget page;

  MenuItem(
      {required this.title,
      required this.icon,
      required this.iconColor,
      required this.page});
}

class MenuPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(
        title: "Bildirim Tercihleri",
        icon: Icons.notifications,
        iconColor: Colors.orange,
        page: NotificationScreen()),
    MenuItem(
        title: "Şifreler ve Giriş",
        icon: Icons.key,
        iconColor: Colors.grey,
        page: PasswordScreen()),
    MenuItem(
        title: "Akademik Takvim",
        icon: Icons.calendar_month,
        iconColor: Colors.indigo,
        page: AcademicCalendarScreen()),
    MenuItem(
        title: "Geri Bildirim Gönder",
        icon: Icons.feedback,
        iconColor: Colors.red,
        page: FeedbackScreen()),
    MenuItem(
        title: "Geliştiriciler",
        icon: Icons.people,
        iconColor: Colors.black,
        page: GelistiricilerScreen()),
    MenuItem(
        title: "Rehber",
        icon: Icons.menu_book_outlined,
        iconColor: Colors.brown,
        page: const GuidePage()),
  ];

  MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menü"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];
              return ListTile(
                leading: Icon(
                  menuItem.icon,
                  size: screenWidth * 0.07,
                  color: menuItem.iconColor,
                  // color: Colors.indigo,
                ),
                title: Text(menuItem.title,
                    style: TextStyle(fontSize: screenWidth * 0.045)),
                onTap: () => methods.navigateToPage(context, menuItem.page),
              );
            }));
  }
}

class AcademicCalendarScreen extends StatefulWidget {
  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  final AcademicApi academicApi = AcademicApi();
  late Future<List<Academic>> academicData;

  @override
  void initState() {
    super.initState();
    academicData = academicApi.fetchAcademicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Akademik Takvim",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 226, 225, 225),
      ),
      body: FutureBuilder<List<Academic>>(
        future: academicData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Bir hata oluştu: ${snapshot.error}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final List<Academic> allData = snapshot.data!;
            final List<Map<String, String>> periods = allData
                .where((data) => data.category == "Dönem")
                .map((e) => {
                      "event": e.event!,
                      "startDate": e.startDate!,
                      "endDate": e.endDate!,
                    })
                .toSet()
                .toList();

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: periods.length,
              itemBuilder: (context, index) {
                final period = periods[index];
                final backgroundColors = [
                  const Color.fromARGB(255, 99, 180, 215),
                  const Color.fromARGB(255, 162, 224, 91),
                  const Color.fromARGB(255, 235, 208, 120),
                  Colors.pink[50]
                ];
                return Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 125),
                  child: Card(
                    color: backgroundColors[index % backgroundColors.length],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ExpansionTile(
                      iconColor: Colors.blueAccent,
                      collapsedIconColor: Colors.blueAccent,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          period["event"]!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      children: [_buildSubCategoryList(period, allData)],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSubCategoryList(Map period, List<Academic> allData) {
    final List<String> subCategories = allData
        .where((item) {
          final itemEndDate = item.endDate;
          return DateTime.parse(period["endDate"]!)
                  .isAfter(DateTime.parse(itemEndDate!)) &&
              DateTime.parse(period["startDate"]!)
                  .isBefore(DateTime.parse(item.startDate!));
        })
        .map((e) => e.category!)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subCategories.map((subCategory) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                subCategory,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return _buildDetailsList(subCategory, period, allData);
                  },
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailsList(
      String category, Map period, List<Academic> allData) {
    final List<Academic> filteredData = allData.where((item) {
      return item.category == category && period["event"] == item.term;
    }).toList();

    if (filteredData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Bu kategoriye ait veri bulunamadı.",
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final detail = filteredData[index];
        String formattedStartDate = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(detail.startDate!).toLocal());
        String formattedEndDate = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(detail.endDate!).toLocal());

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.blue[50],
          child: ListTile(
            leading: const Icon(
              Icons.event,
              color: Colors.blueAccent,
            ),
            title: Text(
              detail.event!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("📅 $formattedStartDate - $formattedEndDate"),
          ),
        );
      },
    );
  }
}

class PasswordScreen extends StatefulWidget {
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController canvasMail = TextEditingController();
  TextEditingController canvasPassword = TextEditingController();
  TextEditingController prepCanvasMail = TextEditingController();
  TextEditingController prepCanvasPassword = TextEditingController();
  TextEditingController zimbraMail = TextEditingController();
  TextEditingController zimbraPassword = TextEditingController();
  TextEditingController sisMail = TextEditingController();
  TextEditingController sisPassword = TextEditingController();
  bool isChecked = false;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
    checkDialogPreference(); // Dialog tercih kontrolü
  }

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      canvasMail.text = prefs.getString("canvasMail") ?? "";
      canvasPassword.text = prefs.getString("canvasPassword") ?? "";
      prepCanvasMail.text = prefs.getString("prepCanvasMail") ?? "";
      prepCanvasPassword.text = prefs.getString("prepCanvasPassword") ?? "";
      zimbraMail.text = prefs.getString("zimbraMail") ?? "";
      zimbraPassword.text = prefs.getString("zimbraPassword") ?? "";
      sisMail.text = prefs.getString("sisMail") ?? "";
      sisPassword.text = prefs.getString("sisPassword") ?? "";
    });
  }

  Future<void> checkDialogPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool shouldShowDialog =
        prefs.getBool("showPrivacyDialog") ?? true; // Varsayılan: true
    if (shouldShowDialog && !_isDialogShown) {
      _isDialogShown = true;
      Future.microtask(() => _showPrivacyDialog());
    }
  }

  Future<void> saveCredentials(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("canvasMail", canvasMail.text);
    await prefs.setString("canvasPassword", canvasPassword.text);
    await prefs.setString("prepCanvasMail", prepCanvasMail.text);
    await prefs.setString("prepCanvasPassword", prepCanvasPassword.text);
    await prefs.setString("zimbraMail", zimbraMail.text);
    await prefs.setString("zimbraPassword", zimbraPassword.text);
    await prefs.setString("sisMail", sisMail.text);
    await prefs.setString("sisPassword", sisPassword.text);

    // Kullanıcıya bilgilendirme mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bilgiler başarıyla kaydedildi!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _saveDialogPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showPrivacyDialog", value);
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Gizlilik Bildirimi"),
              content: const Text(
                "Merak etmeyin, girdiğiniz bilgiler yalnızca sizin erişiminiz için güvenli bir şekilde saklanmaktadır ve üçüncü taraflarla kesinlikle paylaşılmamaktadır. "
                "Bu veriler, yalnızca uygulama içerisindeki öğrenci giriş işlemlerinizi kolaylaştırmak amacıyla tutulmaktadır. Güvenliğiniz bizim önceliğimizdir.",
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    const Text("Bir daha gösterme"),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _saveDialogPreference(
                        !isChecked); // Kullanıcı tercihini kaydet
                    Navigator.of(context).pop(); // Dialog'u kapat
                  },
                  child: const Text("Anladım"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için controller'ları temizle
    canvasMail.dispose();
    canvasPassword.dispose();
    prepCanvasMail.dispose();
    prepCanvasPassword.dispose();
    zimbraMail.dispose();
    zimbraPassword.dispose();
    sisMail.dispose();
    sisPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Bilgileri"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Canvas Bilgileri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              methods.buildTextField(
                  "Canvas Mail", const Icon(Icons.email), canvasMail),
              const SizedBox(height: 10),
              methods.buildPasswordField(
                  "Canvas Şifre", const Icon(Icons.lock), canvasPassword),
              const SizedBox(height: 20),
              const Text(
                "Hazırlık Canvas Bilgileri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              methods.buildTextField(
                  "Canvas Mail", const Icon(Icons.email), prepCanvasMail),
              const SizedBox(height: 10),
              methods.buildPasswordField(
                  "Canvas Şifre", const Icon(Icons.lock), prepCanvasPassword),
              const SizedBox(height: 20),
              const Text(
                "Zimbra Bilgileri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              methods.buildTextField(
                  "Zimbra Mail", const Icon(Icons.email), zimbraMail),
              const SizedBox(height: 10),
              methods.buildPasswordField(
                  "Zimbra Şifre", const Icon(Icons.lock), zimbraPassword),
              const SizedBox(height: 20),
              const Text(
                "SIS Bilgileri",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              methods.buildTextField(
                  "Öğrenci ID numarası", const Icon(Icons.email), sisMail),
              const SizedBox(height: 10),
              methods.buildPasswordField(
                  "SIS Şifre", const Icon(Icons.lock), sisPassword),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () => saveCredentials(context),
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isNotificationsEnabled = false; // Varsayılan değer
  bool isLessonNotification = false;
  bool isRefectoryNotification = false;
  bool isAttendanceNotification = false;
  TextEditingController txtMinute = TextEditingController();

  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    loadNotificationPreference(); // Kullanıcının tercihini yükle
    loadMinute();
  }

  // Kullanıcının tercih ettiği bildirim durumunu yükle
  Future<void> loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled =
          prefs.getBool('isNotificationsEnabled') ?? false; // Varsayılan: false
      isLessonNotification = prefs.getBool("isLessonNotification") ?? false;
      isRefectoryNotification =
          prefs.getBool("isRefectoryNotification") ?? false;
      isAttendanceNotification =
          prefs.getBool("isAttendanceNotification") ?? false;
    });
  }

  // Kullanıcının tercih ettiği bildirim durumunu kaydet
  Future<void> SavePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> SaveMinute(String minute) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("txtMinute", minute);
  }

  Future<void> loadMinute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMinute = prefs.getString("txtMinute");

    if (savedMinute != null && savedMinute.isNotEmpty) {
      txtMinute.text = savedMinute;
    }
  }

  void toggleNotification(bool value) async {
    setState(() {
      isNotificationsEnabled = value;
      requestNotificationPermission(context);
    });

    SavePreference("isNotificationsEnabled", value);

    if (!value) {
      methods.printColored(
          "Kullanıcı bildirimleri kapattı. Tüm bildirimler iptal ediliyor...",
          "32");
      await notificationService.cancelAllNotifications();
    } else {
      methods.printColored("Kullanıcı bildirimleri açtı.", "32");
    }
  }

  void toggleRefectoryNotification(bool value) async {
    setState(() {
      isRefectoryNotification = value;
    });
    SavePreference("isRefectoryNotification", value);

    if (!value) {
      methods.printColored(
          "Kullanıcı yemekhane bildirimlerini kapattı. Yemekhane bildirimleri iptal ediliyor.",
          "32");
      await notificationService.cancelNotification(1000);
    } else {
      methods.printColored(
          "Yemek bildirimleri açıldı. Yeniden zamanlanıyor...", "32");
      await notificationService.scheduleRefectoryNotification(
          1000,
          "Yemekhane Bildirimi",
          "Yemek servisi başladı. Bugünün menüsünü görmek için tıkla.",
          11,
          0);
    }
  }

  void toggleLessonNotification(bool value) async {
    Dbhelper dbhelper = Dbhelper();
    List<Lesson>? lessons;
    var recordLessons = dbhelper.getLessons();
    recordLessons.then((data) {
      setState(() {
        lessons = data;
        isLessonNotification = value;

        if (!value) {
          methods.printColored(
              "Kullanıcı ders bildirimlerini kapattı. Ders bildirimleri iptal ediliyor. ${lessons!.length}",
              "32");
          for (int i = 1; i <= lessons!.length; i++) {
            notificationService.cancelNotification(i);
          }
        } else {
          methods.printColored(
              "Ders bildirimleri açıldı. Yeniden zamanlanıyor...", "32");
        }
      });
    });

    SavePreference("isLessonNotification", value);
  }

  void toggleAttendanceNotification(bool value) async {
    setState(() {
      isAttendanceNotification = value;
    });

    SavePreference("isAttendanceNotification", value);

    if (!value) {
      methods.printColored(
          "Kullanıcı devamsızlık bildirimlerini kapattı. Devamsızlık bilidirimleri iptal ediliyor...",
          "32");
      await notificationService.cancelNotification(2000);
    } else {
      methods.printColored(
          "Kullancı devamsızlık bildirimlerini açtı. Yendiden zamanlanıyor...",
          "32");
      await notificationService.scheduleAttendanceNotification(
          2000,
          "Devamsızlık Bildirimi",
          "Günlük devamsızlık kaydınızı girmeyi unutmayın.",
          21,
          0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirim Ayarları"),
        centerTitle: true,
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(10.0), // Listeye kenarlardan boşluk ekledim
        children: [
          const Text(
            "Genel Bildirimler",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 10), // Bildirim başlığından sonra boşluk
          Card(
            elevation: 2, // Hafif gölge efekti
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                size: 30,
                color: Colors.indigo,
              ),
              title: const Text(
                "Bildirimler",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                isNotificationsEnabled
                    ? "Bildirimler açık. Alt bildirimleri düzenleyebilirsiniz."
                    : "Bildirimler kapalı.",
                style: TextStyle(
                  fontSize: 14,
                  color: isNotificationsEnabled ? Colors.green : Colors.red,
                ),
              ),
              trailing: Switch(
                value: isNotificationsEnabled,
                onChanged: toggleNotification,
                activeColor: Colors.green,
              ),
            ),
          ),
          const Divider(),

          // Yemekhane Bildirimi
          const Text(
            "Yemekhane Bildirimleri",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.restaurant,
                size: 30,
                color: Colors.indigo,
              ),
              title: const Text(
                "Yemekhane Bildirimi",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                isRefectoryNotification
                    ? "Yemekhane bildirimleri açık."
                    : "Yemekhane bildirimleri kapalı.",
                style: TextStyle(
                  fontSize: 14,
                  color: isRefectoryNotification ? Colors.green : Colors.red,
                ),
              ),
              trailing: Switch(
                value: isRefectoryNotification,
                onChanged: isNotificationsEnabled
                    ? (value) => toggleRefectoryNotification(value)
                    : null,
                activeColor: Colors.green,
              ),
            ),
          ),
          const Divider(),

          const Text(
            "Devamsızlık Bildirimleri",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.person_remove,
                size: 30,
                color: Colors.indigo,
              ),
              title: const Text(
                "Devamsızlık Bildirimleri",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                isAttendanceNotification
                    ? "Devamsızlık bildirimleri açık"
                    : "Devamsızlık bildirimleri kapalı",
                style: TextStyle(
                    fontSize: 14,
                    color:
                        isAttendanceNotification ? Colors.green : Colors.red),
              ),
              trailing: Switch(
                value: isAttendanceNotification,
                onChanged: isNotificationsEnabled
                    ? (value) => toggleAttendanceNotification(value)
                    : null,
                activeColor: Colors.green,
              ),
            ),
          ),
          const Divider(),
          // Ders Bildirimi
          const Text(
            "Ders Bildirimleri",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.school,
                size: 30,
                color: Colors.indigo,
              ),
              title: const Text(
                "Ders Bildirimleri",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                isLessonNotification
                    ? "Ders bildirimleri açık. Bildirim ayarlarını düzenleyebilirsiniz."
                    : "Ders bildirimleri kapalı.",
                style: TextStyle(
                  fontSize: 14,
                  color: isLessonNotification ? Colors.green : Colors.red,
                ),
              ),
              trailing: Switch(
                value: isLessonNotification,
                onChanged: isNotificationsEnabled
                    ? (value) => toggleLessonNotification(value)
                    : null,
                activeColor: Colors.green,
              ),
            ),
          ),
          const Divider(),

          // Ders Bildirimleri İçin Kaydetme Alanı
          if (isLessonNotification) ...[
            const Text(
              "Ders Bildirim Ayarları",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "Bildirim Süresi (dk)",
                hintText: "Örneğin: 10 dakika önce (Sadece sayı giriniz.)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              controller: txtMinute,
              onChanged: (value) {
                // Girilen değer değiştiğinde kullanıcıya bilgi verebiliriz
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String minute = txtMinute.text;
                final isNumeric = RegExp(r'^\d+$').hasMatch(minute);

                if (minute.isNotEmpty && isNumeric) {
                  await SaveMinute(minute); // Kaydet

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Değer kaydedildi: $minute dakika önce")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Lütfen geçerli bir değer giriniz")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text("Kaydet"),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    txtMinute.dispose(); // Bellek sızıntısını önlemek için controller'ı temizle
    super.dispose();
  }
}

class GelistiricilerScreen extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {
      "name": "Mustafa Biçer",
      "bio": "Bilgisayar Mühendisliği 3. sınıf öğrencisi",
      "image": "assets/images/gelistiriciler/mustafa_bicer.jpg"
    },
    {
      "name": "Mustafa Uğur Karaköse",
      "bio":
          "Merhaba, ben AGÜ'de Bilgisayar Mühendisi 3. sınıf öğrencisiyim. Yapay zeka ve oyun geliştirme üzerine çalışıyorum. Unity ve TensorFlow kullanıyorum. Ek olarak kendimi siber güvenlik konularında geliştirmeye çalışıyorum.",
      "image": "assets/images/gelistiriciler/karakose.jpg"
    },
    {
      "name": "Yunus Başkan",
      "bio":
          "Bilgisayar Mühendisliği 3. sınıf öğrencisiyim ve yapay zeka, veri bilimi ve blockchain teknolojilerine ilgi duyuyorum. Bu alanlarda kendimi geliştirmek için araştırmalar yapıyor, projeler üretiyor ve yeni teknolojileri yakından takip ediyorum.",
      "image": "assets/images/gelistiriciler/yunus_baskan2.jpg"
    },
    {
      "name": "Turgut Alp Yeşil",
      "bio":
          "Bilgisayar Mühendisliği 3. sınıf öğrencisi olarak, yazılım geliştirme, veri yapıları ve problem çözme becerilerimi projelerle güçlendiriyorum. Gelecekte yazılım mühendisliği, yapay zeka, veri bilimi veya siber güvenlik alanlarında başarılı olmayı hedefliyorum.",
      "image": "assets/images/gelistiriciler/turgut_alp.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Geliştiriciler"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 39, 113, 148),
          //Color.fromARGB(255, 255, 255, 255),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 3, // GridView'in ekrana yayılmasını sağlar
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8), // Sağdan ve soldan 8 px boşluk

                shrinkWrap: true, // Yüksekliği içeriğe göre ayarlar
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll'u kapatarak sabit bir görünüm sağlar
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: developers.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(15), // Card köşe yuvarlatma
                      gradient: const LinearGradient(
                        colors: [
                          //const Color.fromARGB(255, 32, 32, 32),
                          //const Color.fromARGB(255, 39, 113, 148)
                          Color.fromARGB(255, 32, 32, 32),
                          Color.fromARGB(255, 39, 113, 148)
                        ], // Gradyan renkler
                        begin: Alignment.topLeft, // Başlangıç noktası
                        end: Alignment.bottomRight, // Bitiş noktası
                      ),
                    ),
                    child: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                developers[index]["image"]!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              developers[index]["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                // Uzun bio'ların taşmasını önler
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    developers[index]["bio"]!,
                                    //textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(), // Alt boşluk ekleyerek GridView'ı ortalamaya yardımcı olur
          ],
        ),
      ),
    );
  }
}

// Bildirim izni isteme fonksiyonu
Future<bool> requestNotificationPermission(BuildContext context) async {
  if (Platform.isAndroid) {
    var status = await Permission.notification.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      var result = await Permission.notification.request();
      if (result.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        // Kullanıcıya "Evet/Hayır" soralım
        bool? goToSettings = await showPermissionDialog(context);
        if (goToSettings == true) {
          openAppSettings(); // Ayarlar sayfasına yönlendir
        }
        return false;
      }
    } else {
      return true; // İzin zaten verilmiş
    }
  }
  return false;
}

Future<bool?> showPermissionDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.notifications_active,
          size: 40,
          color: Colors.indigo,
        ),
        content: const Text(
          "AGU Mobile uygulamasının size bildirim göndermesini ister misiniz?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // "Hayır" seçildi
            },
            child: const Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // "Evet" seçildi
            },
            child: const Text("Evet"),
          ),
        ],
      );
    },
  );
}
