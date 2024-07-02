import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

/// A utility class for managing city preferences.
class CityPreferences {
  static const String _lastSearchedCityKey = 'lastSearchedCity';

  /// Saves the last searched city name to shared preferences.
  static Future<void> saveLastSearchedCity(String cityName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSearchedCityKey, cityName);
  }

  /// Retrieves the last searched city name from shared preferences.
  static Future<String?> getLastSearchedCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSearchedCityKey);
  }
}

/// A widget that displays weather details for a given city.
class WeatherDetail extends StatefulWidget {
  final WeatherData weather;
  final Future<void> Function() refreshWeather;
  final Future<void> Function(String) searchCity;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.refreshWeather,
    required this.searchCity, required String formattedDate, required String formattedTime,
  });

  @override
  _WeatherDetailState createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> with TickerProviderStateMixin {
  late String formattedDate;
  late String formattedTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateDateTime());
    _saveLastSearchedCity();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Updates the formatted date and time.
  void _updateDateTime() {
    setState(() {
      formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
      formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  /// Saves the last searched city to shared preferences.
  Future<void> _saveLastSearchedCity() async {
    await CityPreferences.saveLastSearchedCity(widget.weather.name);
  }

  /// Handles the refresh action.
  Future<void> _handleRefresh() async {
    await widget.refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weather.name),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade100, Colors.blue.shade800],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth > 600 ? 60 : 40,
                    horizontal: screenWidth > 1000 ? 80 : (screenWidth > 600 ? 40 : 20),
                  ),
                  child: screenWidth > 1000
                      ? _buildPCLayout()
                      : (screenWidth > 600 ? _buildTabletLayout() : _buildMobileLayout()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the mobile layout.
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        const SizedBox(height: 30),
        _buildDateTimeInfo(),
        const SizedBox(height: 30),
        _buildWeatherImage(),
        const SizedBox(height: 40),
        _buildWeatherInfoContainer(),
      ],
    );
  }

  /// Builds the tablet layout.
  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildDateTimeInfo(),
                ],
              ),
            ),
            Expanded(child: _buildWeatherImage()),
          ],
        ),
        const SizedBox(height: 40),
        _buildWeatherInfoContainer(),
      ],
    );
  }

  /// Builds the PC layout.
  Widget _buildPCLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildDateTimeInfo(),
              const SizedBox(height: 40),
              _buildWeatherInfoContainer(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildWeatherImage(),
        ),
      ],
    );
  }

  /// Builds the header section with city name and temperature.
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.weather.name,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${widget.weather.temperature.current.toStringAsFixed(1)}°C",
          style: const TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.weather.weather.isNotEmpty)
          Text(
            widget.weather.weather[0].main,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  /// Builds the date and time info section.
  Widget _buildDateTimeInfo() {
    return Column(
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds the weather image section.
  Widget _buildWeatherImage() {
    return Container(
      height: 300,
      width: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/cloudy.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Builds the weather info container section.
  Widget _buildWeatherInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildWeatherInfoRow(
            "Wind", "${widget.weather.wind.speed}km/h",
            "Max", "${widget.weather.maxTemperature.toStringAsFixed(1)}°C",
            "Min", "${widget.weather.minTemperature.toStringAsFixed(1)}°C",
          ),
          const Divider(color: Colors.white60),
          _buildWeatherInfoRow(
            "Humidity", "${widget.weather.humidity}%",
            "Pressure", "${widget.weather.pressure}hPa",
            "Sea Level", "${widget.weather.seaLevel}m",
          ),
        ],
      ),
    );
  }

  /// Builds a row of weather info cards.
  Widget _buildWeatherInfoRow(String title1, String value1, String title2, String value2, String title3, String value3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildWeatherInfoCard(title: title1, value: value1)),
        Expanded(child: _buildWeatherInfoCard(title: title2, value: value2)),
        Expanded(child: _buildWeatherInfoCard(title: title3, value: value3)),
      ],
    );
  }

  /// Builds a single weather info card.
  Widget _buildWeatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
