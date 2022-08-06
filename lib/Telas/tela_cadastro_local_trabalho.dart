import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/local_trabalho.dart';

import '../Modelo/check_box_modelo.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/Servicos/consulta.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaCadastroLocalTrabalho extends StatefulWidget {
  const TelaCadastroLocalTrabalho(
      {Key? key, required this.generoPessoa, required this.itensPessoa})
      : super(key: key);

  final bool generoPessoa;
  final List<String> itensPessoa;

  @override
  State<TelaCadastroLocalTrabalho> createState() => _TelaCadastroPessoasState();
}

class _TelaCadastroPessoasState extends State<TelaCadastroLocalTrabalho> {
  int valorGenero = 0;
  int idItem = 0;
  bool retornoListaVazia = false;
  String tipoEscala = "";
  List<LocalTrabalho> localTrabalho = [];
  List<String> localSelecionados = [];
  final List<CheckBoxModel> itensCheckBox = [];
  final TextEditingController _controllerNome =
      TextEditingController(text: "");

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    consultarTarefas();
    // verificando qual a opcao selecionada na tela inicial
    // caso seja verdadeiro corresponde ao genero feminino
    // e falso corresponde ao genero masculino
    if (widget.generoPessoa) {
      tipoEscala = Textos.btnCooperadoras;
      valorGenero = 1;
    } else {
      tipoEscala = Textos.btnCooperador;
      valorGenero = 0;
    }
  }

  // metodo para inserir os dados no banco de dados
  inserirDados() async {
    // linha para incluir os dados
    Map<String, dynamic> linha = {
      BancoDeDados.columnLocal: _controllerNome.text,
    };
    await bancoDados.inserir(linha, Constantes.bancoTabelaLocalTrabalho);
    consultarTarefas();
  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarTarefas() async {
    // limpando listas
    itensCheckBox.clear();
    localTrabalho.clear();
    // chamando metodo responsavel por pegar os itens no banco de dados
    await Consulta.consultarBancoLocalTrabalho(Constantes.bancoTabelaLocalTrabalho).then((value) {
      setState(() {
        localTrabalho = value;
        // caso a lista retornada nao seja vazia executar comandos abaixo
        if (value.isNotEmpty) {
            adicionarItensCheckBox();
            retornoListaVazia = false;
        } else {
          retornoListaVazia = true;
        }
      });
    });
  }

  // metodo para adicionar itens ao widget de check box
  adicionarItensCheckBox() {
    setState(() {
      for (int i = 0; i < localTrabalho.length; i++) {
        itensCheckBox
            .add(CheckBoxModel(texto: localTrabalho[i].nomeLocal, idItem: localTrabalho[i].id));
      }
      _controllerNome.text = ""; // definindo texto do campo
    });
  }

  pegarItensLocal() {
    for (var element in itensCheckBox) {
      if (element.checked == true) {
        localSelecionados.add(element.texto);
      }
    }
  }

  //metodo para exibir alerta para excluir tarefa do banco de dados
  Future<void> exibirConfirmacaoExcluir(int id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Textos.legAlertExclusao),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    bancoDados.excluir(id, Constantes.bancoTabelaPessoa);
                    consultarTarefas();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(Textos.sucessoExluirItemBanco)));
                    Navigator.pop(context, false);
                  },
                  child: const Text("Excluir")),
            ],
          );
        });
  }

  Widget checkBoxPersonalizado(CheckBoxModel checkBoxModel) => CheckboxListTile(
        activeColor: PaletaCores.corAdtl,
        checkColor: Colors.white,
        secondary: SizedBox(
            width: 30,
            height: 30,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, size: 20),
              onPressed: () {
                exibirConfirmacaoExcluir(checkBoxModel.idItem);
              },
            )),
        title: Text(checkBoxModel.texto),
        value: checkBoxModel.checked,
        onChanged: (value) {
          setState(() {
            checkBoxModel.checked = value!;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            actionsIconTheme: const IconThemeData(
              size: 30,
            ),
            title: Text(Textos.nomeTelaCadastroLocalTrabalho,textAlign: TextAlign.center),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: larguraTela * 0.3,
                child: Text(Textos.txtTipoEscala + tipoEscala,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
            backgroundColor: PaletaCores.corAzul,
            elevation: 0,
          ),
          body: Container(
              height: alturaTela,
              width: larguraTela,
              color: PaletaCores.corAzul,
              child: Stack(
                children: [
                  FundoTela(altura: alturaTela,),
                  Positioned(
                      child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, bottom: 20.0),
                                  child: Text(
                                    Textos.legCadastroLocalTrabalho,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            top: 0.0,
                                            right: 5.0,
                                            bottom: 5.0),
                                        width: larguraTela * 0.5,
                                        child: Form(
                                          key: _chaveFormulario,
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.white),
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return Textos
                                                    .erroTextFieldVazio;
                                              }
                                              return null;
                                            },
                                            controller: _controllerNome,
                                            decoration: InputDecoration(
                                                labelText:
                                                    Textos.labelTextCadLocalTrabalho,
                                                fillColor: Colors.white,
                                                labelStyle: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: Colors.red),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                //definindo estilo do textfied ao ser clicado
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                )),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.black),
                                          primary: Colors.white,
                                          elevation: 5,
                                          shadowColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                        ),
                                        onPressed: () {
                                          if (_chaveFormulario.currentState!
                                              .validate()) {
                                            inserirDados();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(Textos
                                                        .sucessoAddBanco)));
                                          } else {}
                                        },
                                        child: Text(
                                          Textos.btnCadastrar,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      Textos.legLista,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (retornoListaVazia) {
                                          return SizedBox(
                                            height: 200,
                                            child: Center(
                                              child: Text(
                                                Textos.txtListaVazia,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              height: 200,
                                              width: larguraTela,
                                              child: ListView(
                                                children: [
                                                  ...itensCheckBox
                                                      .map((e) =>
                                                          checkBoxPersonalizado(
                                                            e,
                                                          ))
                                                      .toList()
                                                ],
                                              ));
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )))
                    ],
                  ))
                ],
              )),
          bottomNavigationBar: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: PaletaCores.corVerdeCiano,
                    onPressed: () {
                      var dados = {};
                      dados[Constantes.parametroGenero] = widget.generoPessoa;
                      dados[Constantes.parametroListaPessoas] =widget.itensPessoa;
                      dados[Constantes.parametroListaLocal] = localSelecionados;
                      Navigator.pushReplacementNamed(
                          context, Constantes.rotaTelaSelecaoDias,
                          arguments: dados);
                    },
                    child: const Icon(Icons.arrow_forward, size: 30),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const BarraNavegacao()
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ));
  }
}
