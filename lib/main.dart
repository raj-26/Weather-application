import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherforecastapplication_dart/pages/search_bar.dart';
import 'package:weatherforecastapplication_dart/provider/weather_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}