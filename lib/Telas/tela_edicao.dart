import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/estilo.dart';

import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/textos.dart';
import 'package:intl/intl.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaEdicao extends StatefulWidget {
  const TelaEdicao({Key? key, required this.nomeTabela, required this.idItem})
      : super(key: key);

  final String nomeTabela;
  final int idItem;

  @override
  State<TelaEdicao> createState() => _TelaEdicaoState();
}

class _TelaEdicaoState extends State<TelaEdicao> {
  Estilo estilo = Estilo();
  List<Map<dynamic, dynamic>> itens = [];
  List<String> chaves = [];
  List<String> valores = [];
  bool ativarBotaoHora = false;
  DateTime data = DateTime.now();

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    consultarDados();

  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarDados() async {
    await bancoDados
        .consultarPorID(widget.nomeTabela, widget.idItem)
        .then((value) {
      setState(() {
        itens = value;
      });
    });
    pegarValoresIndividual();
  }

  pegarValoresIndividual() {
    //pegando valores de forma individual
    for (var value1 in itens.first.keys) {
      chaves.add(value1.toString().replaceAll("_", " "));
      if (value1.toString().contains(Textos.localHoraTroca)) {
        bool ativarBotaoHora = true;
      }
    }
    for (var value1 in itens.first.values) {
      valores.add(value1.toString());
    }
    //removendo o primeiro index pois contem o id
    chaves.removeAt(0);
    valores.removeAt(0);
    //convertendo string para o tipo data
    data = DateFormat("dd/MM/yyyy", "pt_BR").parse(valores[0]);
  }

  Widget textField(String valorInicial, String label, bool leitura,
          String tipoExibicao) =>
      Container(
        margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          initialValue: valorInicial,
          readOnly: leitura,
          onFieldSubmitted: (valor) {
            print(valor);
          },
          onTap: () async{
            if (leitura && tipoExibicao == "data") {
              DateTime? novaData = await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: PaletaCores.corAdtl,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child!);
                  },
                  context: context,
                  initialDate: data,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100));

              if (novaData == null) return;
              setState(() {
                if (label.contains(Textos.labelDataInicial)) {
                  //dataInicial = novaData;
                } else {
                  //dataFinal = novaData;
                }
              });
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroTextFieldVazio;
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: PaletaCores.corAdtl,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: PaletaCores.corAdtl),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: PaletaCores.corAdtl),
                borderRadius: BorderRadius.circular(5),
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaListagem,
                  arguments: widget.nomeTabela);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaEdicao, textAlign: TextAlign.center),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: larguraTela,
                    height: alturaTela -
                        alturaBarraStatus -
                        alturaAppBar -
                        Constantes.alturaNavigationBar,
                    child: Stack(
                      children: [
                        // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                        FundoTela(
                            altura: alturaTela -
                                alturaBarraStatus -
                                alturaAppBar -
                                Constantes.alturaNavigationBar),
                        Positioned(
                            child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  width: larguraTela,
                                  child: Column(
                                    children: [
                                      Text(
                                        Textos.descricaoTelaEdicao,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: Constantes
                                                .tamanhoLetraDescritivas,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  width: larguraTela,
                                  child: Column(
                                    children: [
                                      Container(
                                          width: larguraTela,
                                          height: alturaTela * 0.4,
                                          child: ListView.builder(
                                            itemCount: chaves.length,
                                            itemBuilder: (context, index) {
                                              if (index == 0) {
                                                return textField(
                                                    valores.elementAt(index),
                                                    chaves.elementAt(index),
                                                    true,
                                                    "data");
                                              } else if (index == 1) {
                                                return textField(
                                                    valores.elementAt(index),
                                                    chaves.elementAt(index),
                                                    true,
                                                    "hora");
                                              } else {
                                                return textField(
                                                    valores.elementAt(index),
                                                    chaves.elementAt(index),
                                                    false,
                                                    "");
                                              }
                                            },
                                          ))
                                    ],
                                  ),
                                ))
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: Constantes.alturaNavigationBar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: Constantes.tamanhoFloatButtonNavigationBar,
                      height: Constantes.tamanhoFloatButtonNavigationBar,
                      child: FloatingActionButton(
                        heroTag: "btnAtualizar",
                        backgroundColor: PaletaCores.corVerdeCiano,
                        onPressed: () {},
                        child: Text(Textos.btnAtualizar,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 60, child: BarraNavegacao()),
                  ],
                ),
              ),
            )));
  }
}
