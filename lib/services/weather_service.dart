import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherinfo/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double lon = position.longitude;
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=d4c4a2f974a7f568db852a7f344a9b65&units=metric'));
    print('siuuuuuuS');
    if (response.statusCode == 200) {
      print('yes');
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to Load');
      throw Exception('Failed to Load');
    }
  }

  Future<Weather> getWeatherD(LatLng latLng) async {
    double lat = latLng.latitude;
    double lon = latLng.longitude;
    http.Response response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=d4c4a2f974a7f568db852a7f344a9b65&units=metric'));
    print('siuuuuuuS');
    if (response.statusCode == 200) {
      print('yes');
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to Load');
      throw Exception('Failed to Load');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
