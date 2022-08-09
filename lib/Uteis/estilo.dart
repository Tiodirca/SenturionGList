import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';

class Estilo {
  ThemeData get estiloGeral => ThemeData(
      primaryColor: PaletaCores.corAdtl,
      fontFamily: 'Comic',
      appBarTheme: const AppBarTheme(color: PaletaCores.corAdtl, elevation: 0),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
          )),

      // estilo dos botoes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.black),
          primary: Colors.white,
          elevation: 5,
          shadowColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      ));
}
