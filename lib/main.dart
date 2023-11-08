import 'package:flutter/material.dart';
import 'package:weatherinfo/pages/weather_page.dart';
import 'package:weatherinfo/routes.dart';
import 'package:weatherinfo/models/stylesApp.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: '/Weather',
      routes: getroutes(),
      theme: stylesApp.darkTheme(context),
    );
  }
}
