import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherinfo/pages/list_page.dart';
import 'package:weatherinfo/pages/weather_page.dart';
import 'package:weatherinfo/services/weather_service.dart';
import 'package:weatherinfo/services/weather_service_RealTime.dart';
import 'package:weatherinfo/models/weather_model_RealTime.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoianVhbmNhc3RpbGxvMjQiLCJhIjoiY2xvczcxenNlMHc5dDJqcXFvMW13NXgxaCJ9.5__6OzqJddXio1-HpU-XFw';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  final _weatherService = WeatherService('d4c4a2f974a7f568db852a7f344a9b65');
  bool error = false;
  final _weatherServiceRA =
      WeatherServiceRA('d4c4a2f974a7f568db852a7f344a9b65');
  WeatherRA? _weatherRA;
  LatLng? myPosition;
  String currentMapStyle = 'mapbox/streets-v12';
  List<Marker> markers = [];
  final mapController = MapController();

  void _changeMapStyle(String mapStyle) {
    setState(() {
      currentMapStyle = mapStyle;
    });
  }

  _fetchWeather(LatLng latLng) async {
    String cityName = await _weatherServiceRA.getCurrentCity(latLng);
    //print(cityName);
    try {
      final weatherRA = await _weatherServiceRA.getWeatherRA(cityName);
      setState(() {
        _weatherRA = weatherRA;
        print(weatherRA.mainCondition);
        print(weatherRA.temperature);
        print(weatherRA.cityName);
        print(latLng);
        error = false;
      });
    } catch (e) {
      print(e);
      print('dio error aaaaaaaa');
      error = true;
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
    try {
      getCurrentLocation();
      loadMarkersFromDatabase();
    } catch (e) {}

    super.initState();
  }

  Future<void> loadMarkersFromDatabase() async {
    Database database1 = await openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE markers(id INTEGER PRIMARY KEY, lat DOUBLE, lng DOUBLE, name TEXT)',
        );
      },
      version: 1,
    );

    await database1.close();

    Database database = await openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      version: 1,
    );

    List<Map<String, dynamic>> markersFromDatabase =
        await database.query('markers');
    if (markersFromDatabase.isNotEmpty) {
      for (var markerData in markersFromDatabase) {
        LatLng latLng = LatLng(markerData['lat'], markerData['lng']);
        String markerName = markerData['name'];
        String cityName = await _weatherServiceRA.getCurrentCity(latLng);
        final weatherRA = await _weatherServiceRA.getWeatherRA(cityName);
        String icon1 = getWeatherAnimation(weatherRA.mainCondition);
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: latLng,
            child: Column(
              children: [
                // Personaliza el contenido del marcador según tus necesidades
                Image.asset(
                  icon1,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                Text(
                  '${weatherRA.temperature.round()}°C',
                  style: TextStyle(
                    fontSize: 12, // Tamaño de fuente deseado
                    // Otros estilos de texto si es necesario
                  ),
                ),
              ],
            ),
          ),
        );
      }

      await database.close();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Map'),
        backgroundColor: Colors.transparent,
        leading: Row(children: <Widget>[
          const SizedBox(width: 5.0),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherPage(),
                ),
              );
            },
          ),
        ]),
        actions: <Widget>[
          SizedBox(width: 20.0),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyMapPage()),
                );
              },
              child: Text('Ir al mapa')),
        ],
      ),
      body: myPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                center: myPosition,
                zoom: 13.0,
                onTap: (point, latLng) {
                  setState(() async {
                    _fetchWeather(latLng);
                    // Obtén el nombre ingresado por el usuario
                    await Future.delayed(Duration(seconds: 4));
                    print(_weatherRA?.mainCondition);
                    print(_weatherRA?.temperature);
                    print(_weatherRA?.cityName);
                    print(latLng);
                    String icon =
                        getWeatherAnimation(_weatherRA?.mainCondition);
                    //mandar un textfield flotante que pregunte por el nombre del marcador
                    if (error == false) {
                      _showNameInputDialog(
                          context, latLng, icon, _weatherRA?.temperature);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'No se encontraron datos para esta ubicación.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Cierra el diálogo
                                },
                                child: Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': currentMapStyle,
                  },
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Mostrar opciones de cambio de estilo de mapa aquí
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/streets-v12');
                            Navigator.pop(context);
                          },
                          child: const Text('Normal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/outdoors-v12');
                            Navigator.pop(context);
                          },
                          child: const Text('Terreno'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/navigation-night-v1');
                            Navigator.pop(context);
                          },
                          child: const Text('Hibrida'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/satellite-v9');
                            Navigator.pop(context);
                          },
                          child: const Text('Satelital'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () async {
              Database database1 = await openDatabase(
                join(await getDatabasesPath(), 'markers_database.db'),
                onCreate: (db, version) {
                  return db.execute(
                    'CREATE TABLE markers(id INTEGER PRIMARY KEY, lat DOUBLE, lng DOUBLE, name TEXT)',
                  );
                },
                version: 1,
              );
              Position position = await determinePosition();
              await database1.insert(
                'markers',
                {
                  'lat': position.latitude,
                  'lng': position.longitude,
                  'name': 'My ubication',
                },
                conflictAlgorithm: ConflictAlgorithm
                    .replace, // Reemplaza el marcador si ya existe
              );
              await database1.close();
            },
            child: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }

  void _showNameInputDialog(
      BuildContext context, LatLng latLng, String icon, double? temp) {
    TextEditingController nameController =
        TextEditingController(text: _weatherRA?.cityName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nombre del marcador'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String markerName = nameController.text;
                markers.add(
                  Marker(
                      width: 80.0,
                      height: 80.0,
                      point: latLng,
                      child: Column(
                        children: [
                          Image.asset(
                            icon,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            '${temp?.round()}°C',
                          )
                        ],
                      )),
                );
                print(latLng);
                await _saveMarkerToDatabase(latLng, markerName);
                //aqui quiero guardar la latLng y markerName
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMarkerToDatabase(LatLng latLng, String markerName) async {
    // Abre la base de datos o crea una nueva si no existe
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE markers(id INTEGER PRIMARY KEY, lat DOUBLE, lng DOUBLE, name TEXT)',
        );
      },
      version: 1,
    );

    // Inserta los datos en la tabla markers
    await database.insert(
      'markers',
      {
        'lat': latLng.latitude,
        'lng': latLng.longitude,
        'name': markerName,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Reemplaza el marcador si ya existe
    );

    // Cierra la base de datos
    await database.close();
  }
}
