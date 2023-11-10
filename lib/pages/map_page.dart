import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN ='pk.eyJ1IjoianVhbmNhc3RpbGxvMjQiLCJhIjoiY2xvczcxenNlMHc5dDJqcXFvMW13NXgxaCJ9.5__6OzqJddXio1-HpU-XFw';
//final myPosition = LatLng(20.517710, -100.804878); 
class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
  
}



class _mapPageState extends State<mapPage> {
   LatLng? myPosition;

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
    } catch (e) {
      
    }
    
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
        actions: <Widget>[
          //boton para favs
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => mapPage()),
              // );
            },
            child: const Text('Lista de ubicaciones Guardadas'),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: myPosition == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: myPosition!,
                minZoom: 5,
                maxZoom: 25,
                initialZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12',
                  },
                ),
                MarkerLayer(markers:[
                Marker(point: myPosition!, 
                child: Icon(
                  Icons.person_pin_circle,
                  color: Colors.red,
                  size: 40,
                )
                ),
                ]
                )
              ],
            ),
    );
  }
}

