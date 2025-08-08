import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:home_page/bottom.dart';
import 'package:home_page/notifications.dart';
import 'package:home_page/utilts/constants/constants.dart';
import 'package:home_page/utilts/models/sisLessons.dart';
import 'package:home_page/utilts/services/apiService.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

late List<sisLessons> _sisLessonsList = [];
late List<dynamic> _lessonsNameList = [];
List<String> secilenDersler = [];
List<String> secilenDersKodlari = [];
String departmantName = "Bilgisayar Mühendisliği";

const List<String> departmenstList = <String>[
  'Bilgisayar Mühendisliği',
  'Endüstri Mühendisliği',
  'Elektrik-Elektronik Mühendisliği',
  'Malzeme Bilimi ve NanoTeknoloji Mühendisliği'
];

class sisLessonsPage extends StatefulWidget {
  sisLessonsPage({
    super.key,
  });

  @override
  State<sisLessonsPage> createState() => _sisLessonsPageState();
}

class _sisLessonsPageState extends State<sisLessonsPage> {
  sisLessonsAPI sisApi = sisLessonsAPI();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataFromSisAPI();
  }

  // Veriyi yükleyen fonksiyonlar
  Future<void> _loadDataFromSisAPI() async {
    try {
      final api = sisLessonsAPI();
      final data = await api.fetchAllLessonData();

      // final compLessons = data["comp"]!;
      // printColored("Sis ten COMP verileri yüklendi", "32");

      // final ieLessons = data["ie"]!;
      // printColored("Sis ten IE verileri yüklendi", "32");

      final lessons = data["${getLessonsFromDepartmentName(departmantName)}"];

      // List<sisLessons> lessons = await sisApi.fetchSisLessonsData();
      printColored("Sis ten veriler yüklendi", "32");

      for (int i = 0; i < lessons!.length; i++) {
        _lessonsNameList.add(lessons[i].ders_adi);
      }
      _lessonsNameList.toSet().toList();

      printColored("Lesson 5: ${_lessonsNameList[4]}", "32");
      printColored(
          "Toplam ders sayısı: ${_lessonsNameList.toSet().toList().length}",
          "32");
      setState(() {
        _sisLessonsList = lessons;
      });
    } catch (e) {
      // Hata durumunda gerekli işlemleri yapabilirsiniz
      print("Error loading data: $e");
    }
  }

  getLessonsFromDepartmentName(String departmantName) {
    switch (departmantName) {
      case "Bilgisayar Mühendisliği":
        return "compData";
      case "Endüstri Mühendisliği":
        return "ieData";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Ders Ekleme"),
          centerTitle: true,
        ),
        bottomNavigationBar: bottomBar2(context, 2),
        body: _sisLessonsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 39, 113, 148),
                  Color.fromARGB(255, 255, 255, 255),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DersSectionExpandablePicker(
                          sisLessonsList: _sisLessonsList,
                          allLessonNames:
                              _lessonsNameList.toSet().toList().cast<String>()
                                ..sort(),
                          secilenDersler: secilenDersler,
                          // dersKodu: secilenDersKodlari,
                          secilenDersKodlari: secilenDersKodlari,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    _lessonsNameList
        .toSet()
        .toList()
        .map<MenuEntry>((dynamic name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = _lessonsNameList.first;

  @override
  Widget build(BuildContext context) {
    return _lessonsNameList.isEmpty
        ? const CircularProgressIndicator()
        : DropdownMenu<String>(
            initialSelection: _lessonsNameList.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            dropdownMenuEntries: menuEntries,
          );
  }
}

/// --- ANA WIDGET ---
class DersSectionExpandablePicker extends StatefulWidget {
  final List<sisLessons> sisLessonsList;
  final List<String> allLessonNames; // _lessonsNameList (duplicateli gelebilir)
  final List<String> secilenDersler; // "DERS - 02" formatinda
  final List<String> secilenDersKodlari; // MATH151(02) gibi UNIQUE kodlar

  const DersSectionExpandablePicker({
    super.key,
    required this.sisLessonsList,
    required this.allLessonNames,
    required this.secilenDersler,
    required this.secilenDersKodlari,
  });

  @override
  State<DersSectionExpandablePicker> createState() =>
      _DersSectionExpandablePickerState();
}

class _DersSectionExpandablePickerState
    extends State<DersSectionExpandablePicker> {
  // ders_kodu -> kayit listesi (detaylar icin O(1))
  late final Map<String, List<sisLessons>> _byCode;
  // ders_adi -> (section -> ders_kodu) (UI secimi icin)
  late final Map<String, Map<String, String>> _codeByLessonSection;

  final _hScroll = ScrollController(); // yatay scroll bar

  // Dialog icindeki search state
  String _search = '';

  @override
  void initState() {
    super.initState();
    _buildIndexes();
  }

  // "BRG(02)" -> "02"
  String _extractSection(String? dersKodu) {
    final code = dersKodu ?? '';
    return code.length >= 5
        ? code.substring(code.length - 4, code.length - 1)
        : '';
  }

  void _buildIndexes() {
    _byCode = {};
    _codeByLessonSection = {};
    for (final e in widget.sisLessonsList) {
      final code = e.ders_kodu ?? '';
      if (code.isEmpty) continue;
      final section = _extractSection(code);
      if (section.isEmpty) continue;

      // byCode
      (_byCode[code] ??= <sisLessons>[]).add(e);

      // ders_adi -> section -> code
      final map = _codeByLessonSection[e.ders_adi] ??= <String, String>{};
      map.putIfAbsent(section, () => code);
    }
  }

  void _openDialog() {
    // Uniq + sort isim listesi (load metodunu bozmadik; burada normalize ediyoruz)
    final uniqNames = widget.allLessonNames.toSet().toList()..sort();

    showDialog(
      context: context,
      builder: (context) {
        // local filtrelenmis isim listesi
        List<String> filtered = uniqNames;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void filter(String q) {
              setStateDialog(() {
                _search = q.toLowerCase();
                filtered = uniqNames
                    .where((name) => name.toLowerCase().contains(_search))
                    .toList();
              });
            }

            return Dialog(
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 520,
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Ders ara...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: filter,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final dersAdi = filtered[i];

                          // Bu derse ait tum section -> code haritasi
                          final sectionsMap = _codeByLessonSection[dersAdi] ??
                              const <String, String>{};
                          final sections = sectionsMap.keys.toList()..sort();

                          return ExpansionTile(
                            title: Text(dersAdi),
                            children: sections.map((section) {
                              final code = sectionsMap[section]!;
                              final isSelected =
                                  widget.secilenDersKodlari.contains(code);

                              return CheckboxListTile(
                                // title: Text("$section"),
                                subtitle: Text(code),
                                value: isSelected,
                                activeColor: Colors.blueAccent,
                                enabled: true,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      // UI etiketi
                                      final label = "$dersAdi - $section";
                                      if (!widget.secilenDersler
                                          .contains(label)) {
                                        widget.secilenDersler.add(label);
                                      }
                                      if (!widget.secilenDersKodlari
                                          .contains(code)) {
                                        widget.secilenDersKodlari.add(code);
                                      }
                                    } else {
                                      final label = "$dersAdi - $section";
                                      widget.secilenDersler.remove(label);
                                      widget.secilenDersKodlari.remove(code);
                                    }
                                  });
                                  setStateDialog(
                                      () {}); // dialog icini de guncelle
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check),
                      label: const Text("Tamam"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Detaylar: yatay scroll, her kolonda max 2 kart ---
  Widget _buildSelectedDetailsList() {
    // 1) Her ders_kodu için tek kart göstereceğiz (aynı koddaki tüm slotlar bir kartta)
    final codes =
        widget.secilenDersKodlari.toSet().toList(); // double-check uniq

    final selectedByCode = codes
        .where((code) => (_byCode[code]?.isNotEmpty ?? false))
        .map((code) => (
              code: code,
              name: _byCode[code]!.first.ders_adi,
              slots:
                  _byCode[code]!, // aynı koddaki tüm gün/saat/derslik kayıtları
            ))
        .toList();

    // if (selectedByCode.isEmpty) {
    //   // return ;
    //   return const Text("Seçilen bir ders yok.",
    //       style: TextStyle(color: Colors.black54));
    // }

    // 2) 2’şerlik “kolon”lara böl (her kolonda max 2 kart olacak)
    List<List<({String code, String name, List<sisLessons> slots})>> chunk2(
        List<({String code, String name, List<sisLessons> slots})> items) {
      final out =
          <List<({String code, String name, List<sisLessons> slots})>>[];
      for (var i = 0; i < items.length; i += 2) {
        out.add(
            items.sublist(i, (i + 2 > items.length) ? items.length : i + 2));
      }
      return out;
    }

    final columns = chunk2(selectedByCode);

    // 3) Kart ölçüleri (ihtiyaca göre oynatabilirsin)
    const cardWidth = 350.0;
    const cardHeight = 270.0;
    const vGap = 10.0;
    final totalHeight =
        cardHeight * 2 + vGap + 12; // 2 kart + aralık + biraz padding

    // 4) Yatay Scrollbar + Row içinde sütunlar, her sütunda en fazla 2 kart
    return
        // secilenDersler.isEmpty
        //     ? Container(
        //         color: Colors.transparent,
        //       )
        //     :
        SizedBox(
      height: totalHeight,
      child: Scrollbar(
        controller: _hScroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _hScroll,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(columns.length, (idx) {
              final col = columns[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    // 1. kart
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: LessonCard(
                        dersKodu: col[0].code,
                        dersAdi: col[0].name,
                        slots: col[0].slots,
                      ),
                    ),
                    SizedBox(height: vGap),
                    // 2. kart opsiyonel
                    if (col.length > 1)
                      SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: LessonCard(
                          dersKodu: col[1].code,
                          dersAdi: col[1].name,
                          slots: col[1].slots,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: _openDialog,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    border: Border(
                        bottom: BorderSide(width: 6.0, color: Colors.amber),
                        left: BorderSide(width: 3.0, color: Colors.amber),
                        right: BorderSide(width: 3.0, color: Colors.amber),
                        top: BorderSide(width: 1.0, color: Colors.amber))),
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "DERS EKLEMEK İÇİN TIKLAYIN",
                    style: TextStyle(fontSize: 23, color: Colors.black),
                  ),
                ))),
        // Tetikleyici alan (textfield + ikon)

        const SizedBox(height: 16),

        // Chip container
        Container(
          width: double.infinity,
          // height: 230,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: secilenDersler.isEmpty ? null : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              // direction: Axis.horizontal,
              children: widget.secilenDersler.map((label) {
                // label: "CALCULUS I - 02" -> code'u bul
                String? dersKodu;
                final parts = label.split(' - ');
                if (parts.length == 2) {
                  final lesson = parts[0];
                  final section = parts[1];
                  dersKodu = _codeByLessonSection[lesson]?[section];
                }
                return Chip(
                  label:
                      Text(label, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      widget.secilenDersler.remove(label);
                      if (dersKodu != null) {
                        widget.secilenDersKodlari.remove(dersKodu);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Detay container (yatay scroll + 2’li kolonlar)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: secilenDersler.isEmpty ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: secilenDersler.isEmpty
                ? null
                : Border.all(color: Colors.grey.shade300),
          ),
          child: _buildSelectedDetailsList(),
        ),
      ],
    );
  }
}

/// --- Detay karti ---
class _LessonCard extends StatelessWidget {
  final sisLessons e;
  const _LessonCard(this.e);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${e.ders_adi} (${e.ders_kodu ?? "-"})',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('Gün: ${e.gun ?? "-"}    Saat: ${e.saat ?? "-"}'),
            Text('Derslik: ${e.derslik ?? "-"}'),
            Text('Öğretim Elemanı: ${e.ogretim_elemani ?? "-"}'),
          ],
        ),
      ),
    );
  }
}

// Tek bir ders için kart
class LessonCard extends StatelessWidget {
  final String dersKodu;
  final String dersAdi;
  final List<sisLessons> slots; // aynı ders_kodu altındaki tüm kayıtlar

  const LessonCard({
    super.key,
    required this.dersKodu,
    required this.dersAdi,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    // haftalık toplam saat: slot sayısı (her slot 1 saat kabul ediliyor)
    final toplamSaat = slots.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık satırı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$dersAdi ($dersKodu)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text('$toplamSaat saat/hafta'),
                  backgroundColor: Colors.blue.shade50,
                  avatar: const Icon(Icons.access_time,
                      size: 18, color: Colors.blue),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Öğretim Elemanı
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    slots.first.ogretim_elemani ?? "-",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Gün/Saat/Derslik listesi
            ...slots.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(s.gun ?? "-", style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(s.saat ?? "-", style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 12),
                      const Icon(Icons.room, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(s.derslik ?? "-",
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
