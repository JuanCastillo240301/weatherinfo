import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weatherinfo/models/weather_model_RealTime.dart';
import 'package:weatherinfo/pages/weather_detail_page.dart';
import 'package:weatherinfo/services/weather_service_RealTime.dart';

class MyMapPage extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  List<Map<String, dynamic>> markersData = [];
  bool error = false;
  final _weatherServiceRA =
      WeatherServiceRA('d4c4a2f974a7f568db852a7f344a9b65');
  Map<int, WeatherRA?> _weatherData = {}; // Usamos el índice como clave

  Future<void> _fetchWeather(LatLng latLng, int index) async {
    String cityName = await _weatherServiceRA.getCurrentCity(latLng);

    try {
      final weatherRA = await _weatherServiceRA.getWeatherRA(cityName);
      if (_weatherData[index] == null) {
        setState(() {
          _weatherData[index] = weatherRA; // Usamos el índice como clave
          error = false;
        });
      }
    } catch (e) {
      print(e);
      print('dio error aaaaaaaa');
      setState(() {
        error = true;
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.gif';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.gif';
      case 'thunderstorm':
        return 'assets/thunder.gif';
      case 'clear':
        return 'assets/sunny.gif';
      default:
        return 'assets/sunny.gif';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkersData();
  }

  Future<void> _loadMarkersData() async {
    // Abre la base de datos o crea una nueva si no existe
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      version: 1,
    );

    // Lee los datos de la tabla markers
    List<Map<String, dynamic>> data = await database.query('markers');

    // Cierra la base de datos
    await database.close();

    setState(() {
      markersData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Lista de Marcadores'),
          backgroundColor: Colors.transparent,
          leading: Row(children: <Widget>[
            const SizedBox(width: 5.0),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
          actions: <Widget>[]),
      body: ListView.separated(
        itemCount: markersData.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.red, // Color de la raya roja
            thickness: 1.0, // Grosor de la raya
          );
        },
        itemBuilder: (context, index) {
          var marker = markersData[index];
          LatLng latLng = LatLng(marker['lat'], marker['lng']);
          String markerName = marker['name'];
          _fetchWeather(latLng, index);

          String icon = getWeatherAnimation(_weatherData[index]?.mainCondition);
          return ListTile(
            title: Text(markerName),
            subtitle: Text(
                'Latitud: ${_weatherData[index]?.temperature.round() ?? 'Cargando...'}°C'),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(icon), // Reemplaza con tu icono
            ),
            onTap: () {
              // Aquí puedes manejar la acción cuando se presiona un elemento
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherDetailPage(latLng: latLng),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
