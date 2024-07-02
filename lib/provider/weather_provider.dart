import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_services.dart';

/// A provider class for managing weather data and search history.
class WeatherProvider extends ChangeNotifier {
  // Private fields
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  List<String> _searchHistory = [];

  // Public getters
  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get searchHistory => _searchHistory;

  // Constructor
  WeatherProvider() {
    _loadSearchHistory();
  }

  /// Loads the search history from shared preferences.
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('searchHistory') ?? [];
    notifyListeners();
  }

  /// Saves the search history to shared preferences.
  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', _searchHistory);
  }

  /// Fetches weather data for a given city name.
  ///
  /// This method also updates the search history and handles any errors.
  Future<void> fetchWeatherData(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherService = WeatherServices();
      _weatherData = await weatherService.fetchWeather(cityName);

      // Update search history
      _updateSearchHistory(cityName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the weather data for the currently loaded city.
  Future<void> refreshWeather() async {
    if (_weatherData != null) {
      await fetchWeatherData(_weatherData!.name);
    }
  }

  /// Updates the search history with a new city name.
  ///
  /// If the city is already in the history, it moves it to the top.
  /// Keeps only the last 5 search entries.
  Future<void> _updateSearchHistory(String cityName) async {
    if (!_searchHistory.contains(cityName)) {
      _searchHistory.insert(0, cityName);
      if (_searchHistory.length > 5) {
        _searchHistory.removeLast();
      }
      await _saveSearchHistory();
    }
  }
}
