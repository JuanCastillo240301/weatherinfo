import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoianVhbmNhc3RpbGxvMjQiLCJhIjoiY2xvczcxenNlMHc5dDJqcXFvMW13NXgxaCJ9.5__6OzqJddXio1-HpU-XFw';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  LatLng? myPosition;
  String currentMapStyle = 'mapbox/streets-v12';
  List<Marker> markers = [];
  final mapController = MapController();

  void _changeMapStyle(String mapStyle) {
    setState(() {
      currentMapStyle = mapStyle;
    });
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
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Map'),
        backgroundColor: Colors.transparent,
        leading: Row(
          children: <Widget>[
            SizedBox(width: 5.0),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: myPosition == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
          center: myPosition,
          zoom: 13.0,
          onTap: (point, latLng) {
            setState(() {
              print(latLng);
              markers.add(
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLng,
                  child:Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                ),
              );
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
                )
                ,
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
                          child: Text('Normal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/outdoors-v12');
                            Navigator.pop(context);
                          },
                          child: Text('Terreno'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/navigation-night-v1');
                            Navigator.pop(context);
                          },
                          child: Text('Hibrida'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _changeMapStyle('mapbox/satellite-v9');
                            Navigator.pop(context);
                          },
                          child: Text('Satelital'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.layers),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              // Agregar marcador en la ubicación actual
              setState(() {
                markers.add(Marker(
                  point: myPosition!,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40,
                  ),
                )
                );
              });
            },
            child: Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }
}
