import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_page/bottom.dart';

import 'package:home_page/notifications.dart';

import 'package:home_page/utilts/models/meal.dart';
import 'package:home_page/utilts/services/apiService.dart';

class RefectoryScreen extends StatefulWidget {
  @override
  State<RefectoryScreen> createState() => _RefectoryScreenState();
}

class _RefectoryScreenState extends State<RefectoryScreen> {
  final MealApi mealApi = MealApi();
  late Future<List<Meal>> meals;
  bool isDailyMenu = true;
  String userId =
      FirebaseAuth.instance.currentUser?.displayName ?? "guest_user";

  void toggleRefectory(bool value) async {
    setState(() {
      isDailyMenu = value;
    });

    if (!value) {
      printColored("Menü 1", "32");
    } else {
      printColored("Menü 2", "32");
    }
  }

  @override
  void initState() {
    super.initState();
    meals = mealApi.fetchMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar2(context, 3),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Günlük Menü",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const SizedBox(width: 15),
            Switch(
              value: isDailyMenu,
              onChanged: (value) => toggleRefectory(value),
              thumbColor:
                  WidgetStateProperty.all(Colors.white), // Thumb sabit beyaz
              trackColor:
                  WidgetStateProperty.all(Colors.grey), // Arka plan sabit gri
              thumbIcon: WidgetStateProperty.all(
                const Icon(Icons.circle,
                    size: 10, color: Colors.white), // Sabit boyutta ikon
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              "Aylık Menü",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 39, 113, 148),
          Color.fromARGB(255, 255, 255, 255),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: FutureBuilder<List<Meal>>(
          future: meals,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Hata: ${snapshot.error}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            } else if (snapshot.hasData && isDailyMenu) {
              final meals = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  DateTime dateTime = DateTime.parse(meal.date!).toLocal();

                  String formattedDate =
                      "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarih ve Gün Bilgisi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              meal.day ?? "Gün Belirtilmemiş",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 8.0),

                        // Yemek Listesi
                        MealText(
                          label: "Çorba",
                          value: meal.soup,
                        ),
                        MealText(label: "Ana Yemek", value: meal.mainMeal),
                        MealText(
                            label: "Vejetaryen",
                            value: meal.mainMealVegetarian),
                        MealText(
                            label: "Yardımcı Yemek", value: meal.helperMeal),
                        MealText(label: "Ekstra", value: meal.dessert),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasData && !isDailyMenu) {
              final meals = snapshot.data;
              DateTime today = DateTime.now();
              DateTime formattedToday =
                  DateTime(today.year, today.month, today.day);

              // Bugüne ait menüleri filtrele
              final todaysMeals = meals!.where((meal) {
                DateTime mealDate = DateTime.parse(meal.date!).toLocal();
                DateTime formattedMealDate =
                    DateTime(mealDate.year, mealDate.month, mealDate.day);
                return formattedMealDate == formattedToday;
              }).toList();

              // Eğer bugüne ait yemek bulunamazsa mesaj göster
              if (todaysMeals.isEmpty) {
                return const Center(
                  child: Text(
                    "Bugün için yemek bilgisi bulunamadı.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: todaysMeals.length,
                itemBuilder: (context, index) {
                  final meal = todaysMeals[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 26), // 10 piksel aşağı kaydır

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight:
                                    Radius.circular(17)), // Köşeleri yumuşatma
                          ),
                          child: const Text(
                            "Çorba",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMealCard(
                        icon: Icons.restaurant_menu,
                        imageUrl: meal.soupImageUrl != null
                            ? Image.network(meal.soupImageUrl!)
                            : Image.network(
                                'https://i20.haber7.net/resize/1280x720//haber/haber7/photos/2018/03/kremali_misir_corbasi_tarifi_1516434373_0053.jpg'),
                        title: meal.soup,
                        mealType: '1_soup',
                        mealId: '1_soup',
                        userId: userId,
                      ),
                      const Divider(
                        color: Colors.deepOrange,
                      ),
                      Transform.translate(
                        offset: const Offset(0, 26), // 10 piksel aşağı kaydır

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight:
                                    Radius.circular(17)), // Köşeleri yumuşatma
                          ),
                          child: const Text(
                            "Ana Yemek",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMealCard(
                        icon: Icons.restaurant,
                        imageUrl: meal.mealImageUrl != null
                            ? Image.network(meal.mealImageUrl!)
                            : Image.network(
                                'https://i20.haber7.net/resize/1280x720//haber/haber7/photos/2018/03/kremali_misir_corbasi_tarifi_1516434373_0053.jpg'),
                        title: meal.mainMeal,
                        mealType: '2_mainMeal',
                        mealId: '2_mainMeal',
                        userId: userId,
                      ),
                      const Divider(
                        color: Colors.deepOrange,
                      ),
                      Transform.translate(
                        offset: const Offset(0, 26), // 10 piksel aşağı kaydır

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight:
                                    Radius.circular(17)), // Köşeleri yumuşatma
                          ),
                          child: const Text(
                            "Vejetaryen Yemek",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMealCard(
                        icon: Icons.local_dining,
                        imageUrl: meal.mealImageUrl != null
                            ? Image.network(meal.vegetarianImageUrl!)
                            : Image.network(
                                'https://www.diyetkolik.com/site_media/media/foodrecipe_images/besamelsoslubrokoli.jpg'),
                        title: meal.mainMealVegetarian,
                        mealType: '3_mainMealVegetarian',
                        mealId: '3_mainMealVegetarian',
                        userId: userId,
                      ),
                      const Divider(
                        color: Colors.deepOrange,
                      ),
                      Transform.translate(
                        offset: const Offset(0, 26), // 10 piksel aşağı kaydır

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight:
                                    Radius.circular(17)), // Köşeleri yumuşatma
                          ),
                          child: const Text(
                            "Yardımcı Yemek",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMealCard(
                        icon: Icons.rice_bowl,
                        imageUrl: meal.helperMealImageUrl != null
                            ? Image.network(meal.helperMealImageUrl!)
                            : Image.network(
                                'https://i20.haber7.net/resize/1280x720//haber/haber7/photos/2018/03/kremali_misir_corbasi_tarifi_1516434373_0053.jpg'),
                        title: meal.helperMeal,
                        mealType: '4_helperMeal',
                        mealId: '4_helperMeal',
                        userId: userId,
                      ),
                      const Divider(
                        color: Colors.deepOrange,
                      ),
                      Transform.translate(
                        offset: const Offset(0, 26), // 10 piksel aşağı kaydır

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white, // Arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight:
                                    Radius.circular(17)), // Köşeleri yumuşatma
                          ),
                          child: const Text(
                            "Ekstra",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMealCard(
                        mealType: '5_dessert',
                        icon: Icons.cake,
                        imageUrl: meal.dessertImageUrl != null
                            ? Image.network(meal.dessertImageUrl!)
                            : Image.network(
                                'https://i20.haber7.net/resize/1280x720//haber/haber7/photos/2018/03/kremali_misir_corbasi_tarifi_1516434373_0053.jpg'),
                        title: meal.dessert,
                        mealId: '5_dessert',
                        userId: userId,
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "Yemek bilgisi bulunamadı.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _buildMealCard({
  required IconData icon,
  required Image imageUrl,
  required String? title,
  required String mealId, // Firebase için benzersiz yemek ID'si
  required String userId, // Kullanıcı ID'si
  required String mealType, // '1_soup', '2_mainMeal' vb.
}) {
  final now = DateTime.now();
  final String formattedDate = "${now.day}.${now.month}.${now.year}";

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('ratings')
        .doc(formattedDate)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      var mealData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

      // 📌 Eğer Firestore'da ilgili yemek için veri yoksa, 0 olarak ayarla
      double averageRating =
          (mealData[mealType]?['averageRating'] ?? 0.0).toDouble();
      int ratingCount = (mealData[mealType]?['ratingCount'] ?? 0);

      return MealCard(
        icon: icon,
        imageUrl: imageUrl,
        title: title,
        mealId: mealId,
        userId: userId,
        averageRating: averageRating,
        ratingCount: ratingCount,
      );
    },
  );
}

class MealCard extends StatefulWidget {
  final IconData icon;
  final Image imageUrl;
  final String? title;
  final String mealId;
  final String userId;
  final double averageRating;
  final int ratingCount;

  const MealCard({
    required this.icon,
    required this.imageUrl,
    required this.title,
    required this.mealId,
    required this.userId,
    required this.averageRating,
    required this.ratingCount,
  });

  Future<String?> getFirestoreId() async {
    final docRef = FirebaseFirestore.instance.collection('refectory').doc();
    return docRef.id;
  }

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  double? _selectedRating;
  bool _showButtons = false;
  double? _currentAverageRating;
  int _ratingCount = 0; // **🔥 _ratingCount EKLENDİ**
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _currentAverageRating = widget.averageRating;
    _ratingCount = widget.ratingCount;

    // Firestore’dan en güncel verileri çek
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    final now = DateTime.now();
    final String formattedDate = "${now.day}.${now.month}.${now.year}";
    final ratingDocRef =
        FirebaseFirestore.instance.collection('ratings').doc(formattedDate);

    final ratingDoc = await ratingDocRef.get();

    if (ratingDoc.exists) {
      final data = ratingDoc.data() as Map<String, dynamic>;
      if (data.containsKey(widget.mealId)) {
        setState(() {
          _currentAverageRating =
              (data[widget.mealId]['averageRating'] ?? 0.0).toDouble();
          _ratingCount = data[widget.mealId]['ratingCount'] ?? 0;
        });
      }
    }
  }

  Future<String?> getUsername() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final String? email = auth.currentUser?.email;
    if (email == null) {
      return null; // Kullanıcı giriş yapmamış
    }

    // Kullanıcıyı e-posta ile Firestore'da bul
    final QuerySnapshot userQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final Map<String, dynamic> userData =
          userQuery.docs.first.data() as Map<String, dynamic>;
      return userData['username']; // Kullanıcı adını döndür
    }

    return null; // Kullanıcı bulunamazsa
  }

  //SUBMIT fonksiyonu
  Future<void> _submitRate(String mealType, double rating) async {
    final now = DateTime.now();
    final String formattedDate = "${now.day}.${now.month}.${now.year}";

    final openTime = DateTime(now.year, now.month, now.day, 11, 20);

    if (now.isBefore(openTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("puan verme işlemi saat 11.20 de başlar!")),
      );
      return;
    }

    final username = await getUsername();
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı adı bulunamadı!")),
      );
      return;
    }

    final ratingDocRef =
        FirebaseFirestore.instance.collection('ratings').doc(formattedDate);
    final ratingDoc = await ratingDocRef.get();
    Map<String, dynamic> ratingsMap = {};

    if (!ratingDoc.exists) {
      await ratingDocRef.set({
        '1_soup': {'averageRating': 0.0, 'ratingCount': 0, 'userRatings': {}},
        '2_mainMeal': {
          'averageRating': 0.0,
          'ratingCount': 0,
          'userRatings': {}
        },
        '3_mainMealVegetarian': {
          'averageRating': 0.0,
          'ratingCount': 0,
          'userRatings': {}
        },
        '4_helperMeal': {
          'averageRating': 0.0,
          'ratingCount': 0,
          'userRatings': {}
        },
        '5_dessert': {
          'averageRating': 0.0,
          'ratingCount': 0,
          'userRatings': {}
        },
        'createdAt': now,
      }, SetOptions(merge: true));
    } else {
      ratingsMap = ratingDoc.data() as Map<String, dynamic>;
    }

    // Kullanıcı bu yemeğe zaten puan vermiş mi kontrol et
    if (ratingsMap[mealType]?['userRatings']?.containsKey(username) ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu yemeği zaten puanladınız!")),
      );
      return;
    }

    Map<String, dynamic> mealData = ratingsMap[mealType] ??
        {'averageRating': 0.0, 'ratingCount': 0, 'userRatings': {}};

    double currentAvgRating = mealData['averageRating']?.toDouble() ?? 0.0;
    int currentRatingCount = mealData['ratingCount'] ?? 0;

    // Yeni ortalama puanı hesapla
    double newAverageRating =
        ((currentAvgRating * currentRatingCount) + rating) /
            (currentRatingCount + 1);

    // Güncellenmiş veriyi ekle
    mealData['averageRating'] = newAverageRating;
    mealData['ratingCount'] = currentRatingCount + 1;
    mealData['userRatings'] ??= {}; // Eğer daha önce yoksa, oluştur
    mealData['userRatings'][username] = rating; // Kullanıcının puanını ekle

    // Firestore'a yaz
    ratingsMap[mealType] = mealData;
    await ratingDocRef.set(ratingsMap, SetOptions(merge: true));

    // Güncellenmiş veriyi Firestore'dan çek
    final updatedDoc = await ratingDocRef.get();
    final updatedData = updatedDoc.data() as Map<String, dynamic>;

    setState(() {
      _currentAverageRating = updatedData[mealType]['averageRating'];
      _ratingCount = updatedData[mealType]['ratingCount'];
      _hasRated = true;
      _showButtons = false; // Oy verildikten sonra butonları gizle
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Oyunuz başarıyla kaydedildi!")),
    );
  }

  void _showUserRatingsBottomSheet(
      BuildContext context, String mealType) async {
    final now = DateTime.now();
    final String formattedDate = "${now.day}.${now.month}.${now.year}";
    final ratingDocRef =
        FirebaseFirestore.instance.collection('ratings').doc(formattedDate);
    final ratingDoc = await ratingDocRef.get();

    if (!ratingDoc.exists || !ratingDoc.data()!.containsKey(mealType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Henüz bu yemek için puan verilmemiş.")),
      );
      return;
    }

    final mealData = ratingDoc.data()![mealType];
    final userRatings = mealData['userRatings'] ?? {};

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getUserDetails(
              userRatings), // 🔥 Kullanıcı detaylarını tek seferde getir
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userList = snapshot.data ?? [];

            return Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                children: [
                  Text(
                    "${widget.title} - Kullanıcı Puanları",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: userList.isEmpty
                        ? const Center(child: Text("Henüz kimse oy vermemiş."))
                        : ListView.builder(
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              final user = userList[index];

                              return ListTile(
                                leading: user['image_url'].isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user['image_url']))
                                    : CircleAvatar(
                                        child: Text(
                                            user['name'][0].toUpperCase())),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // ⭐ Yıldızları sağ tarafa hizala
                                  children: [
                                    Expanded(
                                      // Uzun isimlerin kaymasını önlemek için
                                      child: Text(
                                          "${user['name']} ${user['surname']}"),
                                    ),
                                    _buildStarRating(user[
                                        'rating']), // ⭐ Yıldızları yanına al
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kapat", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor(); // Tam dolu yıldız sayısı
    bool hasHalfStar = rating - fullStars >= 0.5; // Yarım yıldız kontrolü
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // Boş yıldızlar

    return Row(
      children: [
        // Dolu yıldızları ekle ⭐⭐⭐
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Colors.amber, size: 18),

        // Yarım yıldız ekle (varsa) ⭐
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 18),

        // Boş yıldızları ekle ☆☆☆
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, color: Colors.grey, size: 18),

        const SizedBox(width: 6), // ⭐ ile sayı arasında boşluk bırak
        Text(
          rating.toStringAsFixed(
              1), // Ondalıklı sayı formatında yazdır (4.5 gibi)
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _getUserDetails(
      Map<String, dynamic> userRatings) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> userList = [];

    for (String username in userRatings.keys) {
      final QuerySnapshot userQuery = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data() as Map<String, dynamic>;

        userList.add({
          'name': userData['Name'] ?? '',
          'surname': userData['Surname'] ?? '',
          'image_url': userData['image_url'] ?? '',
          'rating': userRatings[username], // Kullanıcının verdiği puan
        });
      }
    }

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: widget.imageUrl,
              title: Text(
                widget.title ?? "Belirtilmemiş",
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return RatingBar.builder(
                            initialRating: _selectedRating ??
                                _currentAverageRating ??
                                widget.averageRating,
                            minRating: 0.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 16.0,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(Icons.star,
                                color: Colors.amber, size: 16.0),
                            ignoreGestures: _hasRated,
                            onRatingUpdate: (rating) {
                              setState(() {
                                _selectedRating = rating;
                                _showButtons = true;
                              });
                            },
                          );
                        },
                      ),
                      //const SizedBox(width: 8),
                      Text(
                        (_currentAverageRating ?? widget.averageRating)
                            .toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.people_rounded),
                        onPressed: () {
                          _showUserRatingsBottomSheet(context, widget.mealId);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(_ratingCount.toString()),
                    ],
                  ),
                  const SizedBox(height: 23),
                ],
              ),
            ),
          ),
          if (_showButtons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedRating = null;
                      _showButtons = false;
                      _currentAverageRating =
                          widget.averageRating; // Ortalama değeri geri yükle
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 2.7),
                  child: const Text(
                    "Vazgeç",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedRating != null) {
                      _submitRate(widget.mealId, _selectedRating!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 2.7),
                  child: const Text(
                    "Gönder",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class MealText extends StatelessWidget {
  final String label;
  final String? value;
  final double? fontSize;

  const MealText(
      {Key? key, required this.label, required this.value, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          Expanded(
            child: Text(
              value ?? "Belirtilmemiş",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class RefectoryCard extends StatefulWidget {
  final Future<List<Meal>> Function() fetchMeals;
  const RefectoryCard({Key? key, required this.fetchMeals}) : super(key: key);

  @override
  _RefectoryCardState createState() => _RefectoryCardState();
}

class _RefectoryCardState extends State<RefectoryCard> {
  List<Meal>? cachedMeals;
  DateTime? lastFetchedDate;

  @override
  void initState() {
    super.initState();
    _loadMeals(); // İlk çalıştırmada yemekleri yükle
  }

  Future<void> _loadMeals() async {
    DateTime today = DateTime.now();

    if (cachedMeals != null &&
        lastFetchedDate != null &&
        lastFetchedDate!.day == today.day &&
        lastFetchedDate!.month == today.month &&
        lastFetchedDate!.year == today.year) {
      return;
    }

    List<Meal> meals = await widget.fetchMeals();
    setState(() {
      cachedMeals = meals;
      lastFetchedDate = today;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int currentHour = DateTime.now().hour;

    // Eğer yemekler boşsa veya hafta sonuysa içeriği küçült
    bool noMeals = cachedMeals == null ||
        cachedMeals!.isEmpty ||
        DateTime.now().weekday == DateTime.saturday ||
        DateTime.now().weekday == DateTime.sunday;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.005,
        horizontal: screenWidth * 0.02,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Container(
              decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.green, Colors.lightGreen]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Günün Menüsü",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                  ),
                ],
              ),
            ),
            // İçerik (Hafta Sonu veya Yemek Yoksa Yükseklik Küçülsün)
            Container(
              constraints: BoxConstraints(
                maxHeight:
                    noMeals ? screenHeight * 0.135 : screenHeight * 0.165,
              ),
              child: cachedMeals == null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : _buildMealList(screenWidth, screenHeight, noMeals),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealList(double screenWidth, double screenHeight, bool noMeals) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (noMeals) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Text(
            today.weekday == DateTime.saturday ||
                    today.weekday == DateTime.sunday
                ? "Hafta sonu için yemek bilgisi bulunmamaktadır."
                : "Bugün için yemek bilgisi bulunamadı.",
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      children: cachedMeals!.map((meal) {
        DateTime mealDate = DateTime.parse(meal.date!).toLocal();

        if (mealDate.day == today.day &&
            mealDate.month == today.month &&
            mealDate.year == today.year) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MealText(
                    label: "Çorba",
                    value: meal.soup,
                    fontSize: screenWidth * 0.04),
                MealText(
                    label: "Ana Yemek",
                    value: meal.mainMeal,
                    fontSize: screenWidth * 0.04),
                MealText(
                    label: "Vejeteryan",
                    value: meal.mainMealVegetarian,
                    fontSize: screenWidth * 0.04),
                MealText(
                    label: "Yardımcı Yemek",
                    value: meal.helperMeal,
                    fontSize: screenWidth * 0.04),
                MealText(
                    label: "Ekstra",
                    value: meal.dessert,
                    fontSize: screenWidth * 0.04),
              ],
            ),
          );
        }
        return const SizedBox();
      }).toList(),
    );
  }
}
