import 'package:flutter/material.dart';

import '../Uteis/Constantes.dart';
import '../Uteis/Textos.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaSelecaoIntervalo extends StatefulWidget {
  const TelaSelecaoIntervalo(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas,
      required this.listaDias})
      : super(key: key);
  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;
  final List<String> listaDias;

  @override
  State<TelaSelecaoIntervalo> createState() => _TelaSelecaoIntervaloState();
}

class _TelaSelecaoIntervaloState extends State<TelaSelecaoIntervalo> {
  String tipoEscala = "";
  DateTime data = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
    } else {
      tipoEscala = Textos.btnCooperador;
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(Textos.nomeTelaCadastroPessoas, textAlign: TextAlign.center),
          backgroundColor: PaletaCores.corAdtl,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: larguraTela,
            height: alturaTela - alturaBarraStatus - alturaAppBar - 120,
            child: Stack(
              children: [
                // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                FundoTela(
                    altura:
                        alturaTela - alturaBarraStatus - alturaAppBar - 120),
                Positioned(
                    child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          width: larguraTela,
                          child: Column(
                            children: [
                              Text(
                                Textos.descricaoCadastroPessoas,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    top: 0.0,
                                    right: 5.0,
                                    bottom: 5.0),
                                width: larguraTela * 0.5,
                                child: TextFormField(
                                  onTap: () async {
                                    DateTime? novaData = await showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData.dark().copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: PaletaCores.corAdtl,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black,
                                                ),
                                                dialogBackgroundColor:
                                                    Colors.white,
                                              ),
                                              child: child!);
                                        },
                                        context: context,
                                        initialDate: data,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));

                                    if (novaData == null) return;
                                    setState(() {
                                      data = novaData;
                                    });
                                  },
                                  readOnly: true,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintStyle: const TextStyle(color: Colors.white),
                                      hintText:
                                          '${data.day}/${data.month}/${data.year}',
                                      labelText: Textos.labelTextCadPessoa,
                                      fillColor: Colors.white,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      //definindo estilo do textfied ao ser clicado
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.white),
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                Textos.legLista,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: larguraTela * 0.3,
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: PaletaCores.corVerdeCiano,
                      onPressed: () {},
                      child: const Icon(Icons.arrow_forward, size: 30),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    width: larguraTela * 0.3,
                    child: Text(Textos.txtTipoEscala + tipoEscala,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 15)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const BarraNavegacao()
            ],
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
        return false;
      },
    );
  }
}
