import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'Température App',
    home: TemperaturePage(),
  ));
}


class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() {
    return _TemperaturePageState();
  }
}

class _TemperaturePageState extends State<TemperaturePage> {
  double? temperature;
  String cityName = '';

  final apiKey = '452ccf33179f50ae141516180017eb9d'; // remplace par ta clé API OpenWeatherMap

  Future<void> fetchTemperature(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['main']['temp'];
          cityName = city;
        });
      } else {
        print('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Température App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (temperature != null)
              Text(
                'Température à $cityName : ${temperature!.toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 24),
              ),
            SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => fetchTemperature('Casablanca'),
                  child: Text('Casablanca'),
                ),
                ElevatedButton(
                  onPressed: () => fetchTemperature('Rabat'),
                  child: Text('Rabat'),
                ),
                ElevatedButton(
                  onPressed: () => fetchTemperature('Marrakech'),
                  child: Text('Marrakech'),
                ),
                ElevatedButton(
                  onPressed: () => fetchTemperature('Fes'),
                  child: Text('Fès'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}