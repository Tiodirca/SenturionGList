import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';

class Estilo {
  ThemeData get estiloGeral => ThemeData(
      primaryColor: PaletaCores.corAdtl,
      fontFamily: 'Zubayr',
      appBarTheme: const AppBarTheme(
        color: PaletaCores.corAdtl,
        elevation: 0,
        titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Zubayr'),
      ),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(fontSize: 13, color: Colors.white),
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
          side: const BorderSide(color: Colors.black,width: 1.5),
          primary: Colors.white,
          elevation: 10,
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          shadowColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
      ));
}
