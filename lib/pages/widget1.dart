import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatelessWidget {
  final double temperature;
  final String condition;
  final String dateTime;

  WeatherCard({required this.temperature, required this.condition, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1000,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 80, // Ancho deseado de la animación
              height: 80, // Alto deseado de la animación
              child: Lottie.asset(getWeatherAnimation(condition)),
            ),
            Text(
          '${temperature.round()}°C',
          style: TextStyle(
            fontSize: 24, // Tamaño de fuente deseado
          ),
        ),
        Text(
          condition,
          style: TextStyle(
            fontSize: 20, // Tamaño de fuente deseado
          ),
        ),
        Text(
          dateTime,
          style: TextStyle(
            fontSize: 18, // Tamaño de fuente deseado
          ),
        ),
            // Puedes agregar más contenido como iconos o imágenes del clima aquí
          ],
        ),
      ),
    );
  }

    String getWeatherAnimation(String? mainCondition){
    if(mainCondition ==null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      return 'assets/rain.json';
      case 'thunderstorm':
      return 'assets/thunder.json';
      case 'clear':
       return 'assets/sunny.json';
      default:
       return 'assets/sunny.json';
    }
  }
}
