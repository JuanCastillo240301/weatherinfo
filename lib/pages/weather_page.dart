import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherinfo/models/weather_model.dart';
import 'package:weatherinfo/models/weather_model_RealTime.dart';
import 'package:weatherinfo/pages/map_page.dart';
import 'package:weatherinfo/pages/widget1.dart';
import 'package:weatherinfo/services/weather_service.dart';
import 'package:weatherinfo/services/weather_service_RealTime.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('d4c4a2f974a7f568db852a7f344a9b65');
  final _weatherServiceRA = WeatherServiceRA('d4c4a2f974a7f568db852a7f344a9b65');
  Weather? _weather;
  WeatherRA? _weatherRA;
  String?  result0;
    String?  result1;
      String?  result2;
        String?  result3;
          String?  result4;
            String?  result5;
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print(cityName);
    try {
      final weather = await _weatherService.getWeather(cityName);
      //final weatherRA = await _weatherServiceRA.getWeatherRA(cityName);
      print(weather);
      setState(() {
        _weather = weather;
       // _weatherRA = weatherRA;
        String? temperatureString = _weather?.dateTime0;
List<String> parts = temperatureString!.split(" ");
 result0 = parts[0];
temperatureString = _weather?.dateTime1;
parts = temperatureString!.split(" ");
 result1 = parts[0];
 temperatureString = _weather?.dateTime2;
parts = temperatureString!.split(" ");
 result2 = parts[0];
 temperatureString = _weather?.dateTime3;
parts = temperatureString!.split(" ");
 result3 = parts[0];
 temperatureString = _weather?.dateTime4;
parts = temperatureString!.split(" ");
 result4 = parts[0];
 temperatureString = _weather?.dateTime5;
parts = temperatureString!.split(" ");
 result5 = parts[0];
        //print("object");
      });
    } catch (e) {
      print(e);
    }
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

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        elevation: 0,
        title: Text('Weather App'),
        backgroundColor: Colors.transparent,
        leading: Row(
          children: <Widget>[
            SizedBox(width: 5.0),
          ],
        ),
        actions: <Widget>[
          //boton para favs
          ElevatedButton(onPressed: (){
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mapPage()),
              );

          }, child: Text('Ir al mapa')),
          SizedBox(width: 20.0),
        ],
      ),
    body: _weather?.cityName == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          :Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
  _weather?.cityName ?? "Loading city...",
  style: TextStyle(
    fontSize: 82, // Tamaño de fuente deseado
    // Otros estilos de texto si es necesario
  ),
),          SizedBox(height: 82),
Text(
  "Today",
  style: TextStyle(
    fontSize: 45, // Tamaño de fuente deseado
    // Otros estilos de texto si es necesario
  ),
),
          Lottie.asset(getWeatherAnimation( _weather?.mainCondition0)),
          Text(
            '${_weather?.temperature0.round()}°C',
  style: TextStyle(
    fontSize: 52, // Tamaño de fuente deseado
    // Otros estilos de texto si es necesario
  ),
          ),
          Text(
            _weather?.mainCondition0 ?? "xdd",
            style: TextStyle(
    fontSize: 32, // Tamaño de fuente deseado
    // Otros estilos de texto si es necesario
  ),
            // Estilo de texto personalizado si es necesario
          ),

          SizedBox(height: 16),
          Container(
            height: 200,
             // Altura de cada tarjeta
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                WeatherCard(
                  temperature: _weather?.temperature0 ?? 0.0,
                  condition: _weather?.mainCondition0 ?? "xdd",
                  dateTime: result0 ?? "datetime",
                ),
                WeatherCard(
                  temperature: _weather?.temperature1 ?? 0.0,
                  condition: _weather?.mainCondition1 ?? "xdd",
                  dateTime: result1 ?? "datetime",
                ),
                WeatherCard(
                  temperature: _weather?.temperature2 ?? 0.0,
                  condition: _weather?.mainCondition2 ?? "xdd",
                  dateTime: result2 ?? "datetime",
                ),
                WeatherCard(
                  temperature: _weather?.temperature3 ?? 0.0,
                  condition: _weather?.mainCondition3 ?? "xdd",
                  dateTime: result3 ?? "datetime",
                ),
                WeatherCard(
                  temperature: _weather?.temperature4 ?? 0.0,
                  condition: _weather?.mainCondition4 ?? "xdd",
                  dateTime: result4 ?? "datetime",
                ),
                WeatherCard(
                  temperature: _weather?.temperature5 ?? 0.0,
                  condition: _weather?.mainCondition5 ?? "xdd",
                  dateTime: result5 ?? "datetime",
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
