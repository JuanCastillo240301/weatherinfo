import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weatherinfo/models/weather_model_RealTime.dart';
import 'package:weatherinfo/pages/map_page.dart';
import 'package:weatherinfo/pages/weather_detail_page.dart';
import 'package:weatherinfo/services/weather_service_RealTime.dart';

class MyMapPage extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  LatLng? myPosition;
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

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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
        leading: Row(
          children: <Widget>[
            const SizedBox(width: 5.0),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => mapPage(),
                  ),
                );
              },
            ),
          ],
        ),
        actions: <Widget>[],
      ),
      body: ListView.separated(
        itemCount: markersData.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.red,
            thickness: 1.0,
          );
        },
        itemBuilder: (context, index) {
          var marker = markersData[index];
          LatLng latLng = LatLng(marker['lat'], marker['lng']);
          String markerName = marker['name'];

          if (latLng != myPosition) {
            _fetchWeather(latLng, index);

            String icon =
                getWeatherAnimation(_weatherData[index]?.mainCondition);
            return ListTile(
              title: Text(markerName),
              subtitle: Text(
                'Latitud: ${_weatherData[index]?.temperature.round() ?? 'Cargando...'}°C',
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(icon),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteMarker(index);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherDetailPage(latLng: latLng),
                  ),
                );
              },
            );
          } else {}
          return null;
        },
      ),
    );
  }

  void _deleteMarker(int index) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      version: 1,
    );

    await database.delete(
      'markers',
      where: 'id = ?',
      whereArgs: [markersData[index]['id']],
    );

    await database.close();

    _loadMarkersData();
  }
}
