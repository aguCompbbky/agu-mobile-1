class Meal {
  String? date;
  String? day;
  String? soup;
  String? mainMeal;
  String? mainMealVegetarian;
  String? helperMeal;
  String? dessert;
  String? soupImageUrl;
  String? mealImageUrl;
  String? vegetarianImageUrl;
  String? helperMealImageUrl;
  String? dessertImageUrl;

  Meal.empty();

  Meal(
      this.date,
      this.day,
      this.soup,
      this.mainMeal,
      this.mainMealVegetarian,
      this.helperMeal,
      this.dessert,
      this.soupImageUrl,
      this.mealImageUrl,
      this.vegetarianImageUrl,
      this.helperMealImageUrl,
      this.dessertImageUrl);

  Meal.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    day = json["day"];
    soup = json["soup"];
    if (json["meal"] != null) {
      // 'meal' stringini '-' karakterine göre ayır
      final meal = json["meal"].split("-");
      mainMeal = meal.isNotEmpty ? meal[0].trim() : null; // İlk kısım
      mainMealVegetarian =
          meal.length > 1 ? meal[1].trim() : null; // İkinci kısım
    }
    helperMeal = json["helperMeal"];
    dessert = json["dessert"];

    // 📌 soupImageUrl kontrolü
    if (json.containsKey("soupImageUrl")) {
      print("soupImageUrl Found: ${json["soupImageUrl"]}");
    } else {
      print("soupImageUrl NOT FOUND in JSON!");
    }

    soupImageUrl = json["soupImageUrl"];
    mealImageUrl = json["mealImageUrl"];
    vegetarianImageUrl = json["vegetarianImageUrl"];
    helperMealImageUrl = json["helperMealImageUrl"];
    dessertImageUrl = json["dessertImageUrl"];
  }

  Map toJson() {
    return {
      "date": date,
      "soup": soup,
      "mainMeal": mainMeal,
      "mainMealVegetarian": mainMealVegetarian,
      "helperMeal": helperMeal,
      "dessert": dessert,
      "soupImageUrl": soupImageUrl,
      "mealImageUrl": mealImageUrl,
      "vegetarianImageUrl": vegetarianImageUrl,
      "helperMealImageUrl": helperMealImageUrl,
      "dessertImageUrl": dessertImageUrl,
    };
  }
}
