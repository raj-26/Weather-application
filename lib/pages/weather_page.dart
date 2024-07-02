import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import 'weather_detail.dart';

/// A screen that displays weather information for a specified city.
class WeatherScreen extends StatelessWidget {
  final String city;

  const WeatherScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initiates the weather data fetch when the widget is built.
        future: Provider.of<WeatherProvider>(context, listen: false).fetchWeatherData(city),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Shows a loading indicator while waiting for data.
            return const Center(child: CircularProgressIndicator());
          } else {
            // Uses a Consumer to listen to changes in the WeatherProvider.
            return Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                if (weatherProvider.error != null) {
                  // Displays an error message if there is an error.
                  return Center(child: Text(weatherProvider.error!));
                } else if (weatherProvider.weatherData != null) {
                  // Displays the weather details if the data is available.
                  return WeatherDetail(
                    weather: weatherProvider.weatherData!,
                    refreshWeather: () => weatherProvider.refreshWeather(),
                    searchCity: (String cityName) => weatherProvider.fetchWeatherData(cityName),
                    formattedDate: '',
                    formattedTime: '',
                  );
                } else {
                  // Displays a message if no weather data is available.
                  return const Center(child: Text('No weather data available'));
                }
              },
            );
          }
        },
      ),
    );
  }
}
