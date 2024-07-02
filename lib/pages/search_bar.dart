import 'package:flutter/material.dart';
import 'package:weatherforecastapplication_dart/pages/weather_page.dart';


/// HomeScreen is the main screen of the Weather App.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the city input text field
  final TextEditingController _cityController = TextEditingController();

  // List to keep track of search history
  List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCityInputField(),
            const SizedBox(height: 20),
            _buildGetWeatherButton(),
            const SizedBox(height: 20),
            _buildSearchHistorySection(),
          ],
        ),
      ),
    );
  }

  /// Builds the city input text field.
  Widget _buildCityInputField() {
    return TextField(
      controller: _cityController,
      decoration: const InputDecoration(
        labelText: 'Enter city name',
        border: OutlineInputBorder(),
      ),
    );
  }

  /// Builds the "Get Weather" button.
  Widget _buildGetWeatherButton() {
    return ElevatedButton(
      onPressed: () {
        if (_cityController.text.isNotEmpty) {
          _addToSearchHistory(_cityController.text);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WeatherScreen(city: _cityController.text),
            ),
          );
        }
      },
      child: const Text('Get Weather'),
    );
  }

  /// Builds the search history section.
  Widget _buildSearchHistorySection() {
    return Expanded(
      child: _searchHistory.isEmpty
          ? _buildEmptySearchHistoryMessage()
          : _buildSearchHistoryList(),
    );
  }

  /// Builds a message to display when search history is empty.
  Widget _buildEmptySearchHistoryMessage() {
    return Center(
      child: Text(
        'Enter a city name to get weather information',
        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds the list of search history items.
  Widget _buildSearchHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search History:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_searchHistory[index]),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          WeatherScreen(city: _searchHistory[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Adds a city to the search history.
  void _addToSearchHistory(String city) {
    setState(() {
      if (_searchHistory.contains(city)) {
        _searchHistory.remove(city);
      }
      _searchHistory.insert(0, city);
      if (_searchHistory.length > 5) {
        _searchHistory = _searchHistory.sublist(0, 5);
      }
    });
  }
}
