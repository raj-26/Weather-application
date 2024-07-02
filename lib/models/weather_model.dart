/// Represents weather data for a specific location.
class WeatherData {
  final String name;
  final Temperature temperature;
  final int humidity;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int pressure;
  final int seaLevel;
  final List<WeatherCondition> weather;

  WeatherData({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.seaLevel,
    required this.weather,
  });

  /// Factory method to create a WeatherData object from JSON data.
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'],
      temperature: Temperature.fromJson(json['main']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      maxTemperature: json['main']['temp_max'].toDouble(),
      minTemperature: json['main']['temp_min'].toDouble(),
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'] ?? 0,
      weather: (json['weather'] as List)
          .map((w) => WeatherCondition.fromJson(w))
          .toList(),
    );
  }
}

/// Represents the temperature data.
class Temperature {
  final double current;

  Temperature({required this.current});

  /// Factory method to create a Temperature object from JSON data.
  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(current: json['temp'].toDouble());
  }
}

/// Represents wind data.
class Wind {
  final double speed;

  Wind({required this.speed});

  /// Factory method to create a Wind object from JSON data.
  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed'].toDouble());
  }
}

/// Represents weather condition data.
class WeatherCondition {
  final String main;
  final String description;

  WeatherCondition({required this.main, required this.description});

  /// Factory method to create a WeatherCondition object from JSON data.
  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      main: json['main'],
      description: json['description'],
    );
  }
}
