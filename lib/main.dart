import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'Uteis/ScrollBehaviorPersonalizado.dart';
import 'Uteis/constantes.dart';
import 'Uteis/rotas.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // definindo scroll behavior personalizado para permitir rolagem horizontal no navegador
      scrollBehavior: ScrollBehaviorPersonalizado(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PaletaCores.corAdtl,
        fontFamily: 'Comic',
      ),
      //definicoes usadas no date picker
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      //setando o suporte da lingua usada no data picker
      supportedLocales: const [Locale('pt', 'BR')],
      //definindo rota inicial
      initialRoute: Constantes.rotaTelaInicial,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
