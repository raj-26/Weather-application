import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// A service class to fetch weather data from the OpenWeatherMap API.
class WeatherServices {
  // API key for accessing the OpenWeatherMap API.
  static const String _apiKey = '84f4aa66eda25cb035d428317e04ae40';

  // Base URL for the OpenWeatherMap API.
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Fetches weather data for the given [cityName].
  ///
  /// Returns a [WeatherData] object if the request is successful.
  /// Throws an [Exception] if the request fails.
  Future<WeatherData> fetchWeather(String cityName) async {
    // Construct the full API request URL.
    final Uri requestUrl = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric');

    try {
      // Send the HTTP GET request.
      final http.Response response = await http.get(requestUrl);

      // Check if the response status code indicates success.
      if (response.statusCode == 200) {
        // Parse the response body as JSON and convert it to a WeatherData object.
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        // Throw an exception if the request failed.
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request.
      throw Exception('Failed to load weather data: $e');
    }
  }
}
