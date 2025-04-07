import 'dart:convert';
import 'package:home_page/notifications.dart';
import 'package:home_page/utilts/constants/constants.dart';
import 'package:home_page/utilts/models/academic.dart';
import 'package:home_page/utilts/models/events.dart';
import 'package:home_page/utilts/models/meal.dart';
import 'package:http/http.dart' as http;

class MealApi {
  Future<List<Meal>> fetchMeals() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int currentHour = now.hour;

    try {
      final response = await http.get(Uri.parse(baseUrlRefectory));
      print("Full API Response: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Meal> meals = [];

        for (var item in data) {
          Meal meal = Meal.fromJson(item);
          print(json.encode(data)); // Gelen JSON'u terminale yazdır
          printColored("Soup Image URL: ${meal.soupImageUrl}", "35");
          printColored("Main Meal Image URL: ${meal.mealImageUrl}", "35");
          printColored(
              "vegetarian meal Image URL: ${meal.vegetarianImageUrl}", "35");
          printColored("Helper Image URL: ${meal.helperMealImageUrl}", "35");
          printColored("Dessert Image URL: ${meal.dessertImageUrl}", "35");
          DateTime mealDate = DateTime.parse(meal.date!);

          if (mealDate.isAfter(today) || mealDate.isAtSameMomentAs(today)) {
            meals.add(meal);
          }
        }
        return meals;
      } else {
        throw Exception("Failed to load meals");
      }
    } catch (e) {
      throw Exception("Error :  $e");
    }
  }
}

class AcademicApi {
  Future<List<Academic>> fetchAcademicData() async {
    final url = Uri.parse(baseUrlAcademic);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Academic.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load academic data");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}

class EventsApi {
  Future<List<Events>> fetchEventsData() async {
    final url = Uri.parse(baseUrlEvents);

    try {
      final response = await http.get(url);
      print(
        "Full API Response: ${response.body}",
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Events.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load events data");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }
}
