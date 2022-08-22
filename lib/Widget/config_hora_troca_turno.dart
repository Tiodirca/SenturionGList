import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';

class ConfigHoraTrocaTurno extends StatefulWidget {
  const ConfigHoraTrocaTurno({Key? key}) : super(key: key);

  @override
  State<ConfigHoraTrocaTurno> createState() => _ConfigHoraTrocaTurnoState();
}

class _ConfigHoraTrocaTurnoState extends State<ConfigHoraTrocaTurno> {
  TimeOfDay? horario = const TimeOfDay(hour: 19, minute: 00);

  TextEditingController primeiroHorarioSemana = TextEditingController(text: "");
  TextEditingController segundoHorarioSemana = TextEditingController(text: "");

  TextEditingController primeiroHorarioFinalSemana =
      TextEditingController(text: "");

  TextEditingController segundoHorarioFinalSemana =
      TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //chamando metodo
    recuperarValores();
  }

  //metodo para recuperar o horario gravado no share prefereces
  recuperarValores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //definindo que as variaveis vao receber o
      // valor gravado no share preferences

      // semana
      primeiroHorarioSemana.text =
          prefs.getString(Constantes.primeiroHorarioSemana) ?? '';
      segundoHorarioSemana.text =
          prefs.getString(Constantes.segundoHorarioSemana) ?? '';
      // final de semana
      primeiroHorarioFinalSemana.text =
          prefs.getString(Constantes.primeiroHorarioFinalSemana) ?? '';
      segundoHorarioFinalSemana.text =
          prefs.getString(Constantes.segundoHorarioFinalSemana) ?? '';
    });
  }

  // metodo para gravar valores no share preferences
  gravarValores(String chave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(chave, "${horario!.hour}:${horario!.minute}");
    // retornando mensagem ao usuario
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(Textos.sucessoAtualizarHorario)));
  }

  Widget selecaoHorario(double larguraTela, String label,
          TextEditingController horarioGravado) =>
      Container(
          padding: const EdgeInsets.only(
              left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
          width: larguraTela * 0.6,
          child: TextField(
            readOnly: true,
            controller: horarioGravado,
            onTap: () async {
              TimeOfDay? novoHorario = await showTimePicker(
                context: context,
                initialTime: horario!,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      hintColor: Colors.black,
                      colorScheme: const ColorScheme.dark(
                        primary: Colors.white,
                        onPrimary: PaletaCores.corAdtlLetras,
                        surface: PaletaCores.corAdtl,
                        onSurface: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (novoHorario != null) {
                setState(() {
                  horario = novoHorario;
                  horarioGravado.text = "${horario!.hour}:${horario!.minute}";
                  if (label == Textos.horarioInicialSemana) {
                    gravarValores(Constantes.primeiroHorarioSemana);
                  } else if (label == Textos.horarioFinalSemana) {
                    gravarValores(Constantes.segundoHorarioSemana);
                  } else if (label == Textos.horarioInicialFinalSemana) {
                    gravarValores(Constantes.primeiroHorarioFinalSemana);
                  } else if (label == Textos.horarioFinalFinalSemana) {
                    gravarValores(Constantes.segundoHorarioFinalSemana);
                  }
                });
              }
            },
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: label,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )),
          ));

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return SizedBox(
        height: alturaTela * 0.6,
        width: larguraTela * 0.8,
        child: SingleChildScrollView(
          child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      width: larguraTela * 0.6,
                      child: Text(
                        Textos.descricaoConfigHorarioTrocaTurno,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    selecaoHorario(larguraTela, Textos.horarioInicialSemana,
                        primeiroHorarioSemana),
                    selecaoHorario(larguraTela, Textos.horarioFinalSemana,
                        segundoHorarioSemana),
                    selecaoHorario(
                        larguraTela,
                        Textos.horarioInicialFinalSemana,
                        primeiroHorarioFinalSemana),
                    selecaoHorario(larguraTela, Textos.horarioFinalFinalSemana,
                        segundoHorarioFinalSemana)
                  ],
                ),
              )),
        ));
  }
}
