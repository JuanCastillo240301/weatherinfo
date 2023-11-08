import 'package:flutter/material.dart';

class stylesApp {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: ColorScheme.light(
        primary: Color(0xFFE53935), // Rojo más claro
        secondary: Color(0xFF64B5F6), // Azul claro
      ),
      backgroundColor: Color(0xFFFFFFFF), // Color de fondo blanco
      appBarTheme: AppBarTheme(
        color: Color(0xFFE53935), // Color de la barra de la aplicación
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: Color(0xFFFFFFFF)), // Color del texto principal
        // Otros estilos de texto que desees modificar
      ),
      // Otros efectos que desees agregar
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFFE53935), // Color de los botones
        textTheme: ButtonTextTheme.primary, // Texto de los botones en color claro
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFE53935), // Rojo más claro
        secondary: Color(0xFF64B5F6), // Azul claro
      ),
      backgroundColor: Color(0xFF121212), // Color de fondo oscuro
      appBarTheme: AppBarTheme(
        color: Color(0xFFE53935), // Color de la barra de la aplicación
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: Color(0xFF121212)), // Color del texto principal
        // Otros estilos de texto que desees modificar
      ),
      // Otros efectos que desees agregar
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFFE53935), // Color de los botones
        textTheme: ButtonTextTheme.primary, // Texto de los botones en color claro
      ),
    );
  }
}