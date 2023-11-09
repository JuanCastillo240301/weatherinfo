import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:weatherinfo/models/weather_model_RealTime.dart';
class WeatherServiceRA {
  
static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
final String apiKey;

WeatherServiceRA(this.apiKey);

Future<WeatherRA> getWeatherRA(String cityName) async{
 http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=d4c4a2f974a7f568db852a7f344a9b65&units=metric'));
print('siuuuuuuS');
 if(response.statusCode==200){
  print('yes');
  return WeatherRA.fromJson(jsonDecode(response.body));
 }else{
  print('Failed to Load');
  throw Exception('Failed to Load');
 }
}

}
