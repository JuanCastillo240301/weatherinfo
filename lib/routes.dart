import 'package:flutter/material.dart';
import 'package:weatherinfo/pages/weather_page.dart';
Map<String, WidgetBuilder> getroutes() {
  return {
    '/Weather': (BuildContext context) => const WeatherPage(),
    
  };
  }