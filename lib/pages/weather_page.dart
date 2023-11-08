import 'package:flutter/material.dart';
import 'package:weatherinfo/models/weather_model.dart';
import 'package:weatherinfo/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('d4c4a2f974a7f568db852a7f344a9b65');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Weather App"), // Puedes personalizar el título del AppBar
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _weather?.cityName ?? "Loading city...",
            // Estilo de texto personalizado si es necesario
          ),
          SizedBox(height: 16),
          Text(
            '${_weather?.temperature.round()}°C',
            // Estilo de texto personalizado si es necesario
          ),
          // Puedes agregar iconos o imágenes del clima aquí
        ],
      ),
    ),
  );
}
}
