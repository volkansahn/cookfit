import 'dart:convert';
import 'dart:io';
import 'package:cookfit/meal.dart';
import 'package:http/http.dart' as http;

Future<List<Meal>> fetchMeals() async {
  final url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?intolerances=Dairy,Egg&cuisine=Italian&diet=Vegetarian&includeIngredients=onion,tomato,lelegumes&instructionsRequired=true&addRecipeNutrition=true&number=5&apiKey=1ed8f4808298475983d634e9d6cb1373');
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body) as Map<String, dynamic>;
      final results = parsedJson['results'] as List<dynamic>;

      return results.map((mealJson) => Meal.fromJson(mealJson)).toList();
    } else {
      throw Exception('Failed to fetch meals: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching meals: $error');
    rethrow; // Rethrow the error to be handled at a higher level
  }
}
