import 'package:senturionglist/Uteis/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecupararValorSharePreferences {
  //metodo para recuperar o horario gravado no share prefereces
 static Future<String> recuperarValores(String qualHorario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //definindo que as variaveis vao receber o
    // valor gravado no share preferences
    if (qualHorario == Constantes.recuperarValorSemana) {
      String primeiroHorarioSemana =
          prefs.getString(Constantes.primeiroHorarioSemana) ?? '';
      String segundoHorarioSemana =
          prefs.getString(Constantes.segundoHorarioSemana) ?? '';
      return "$primeiroHorarioSemana troca às $segundoHorarioSemana";
    } else {
      // final de semana
      String primeiroHorarioFinalSemana =
          prefs.getString(Constantes.primeiroHorarioFinalSemana) ?? '';
      String segundoHorarioFinalSemana =
          prefs.getString(Constantes.segundoHorarioFinalSemana) ?? '';
      return "$primeiroHorarioFinalSemana troca às $segundoHorarioFinalSemana";
    }
  }
}
