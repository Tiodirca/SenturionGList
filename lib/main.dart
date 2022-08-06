import 'package:flutter/material.dart';
import 'Uteis/constantes.dart';
import 'Uteis/rotas.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //definindo rota inicial
      initialRoute: Constantes.rotaTelaInicial,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}