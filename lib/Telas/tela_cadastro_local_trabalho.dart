import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/local_trabalho.dart';

import '../Modelo/check_box_modelo.dart';
import '../Uteis/estilo.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/Servicos/consultas.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaCadastroLocalTrabalho extends StatefulWidget {
  const TelaCadastroLocalTrabalho(
      {Key? key, required this.genero, required this.listaPessoas})
      : super(key: key);

  final bool genero;
  final List<String> listaPessoas;

  @override
  State<TelaCadastroLocalTrabalho> createState() => _TelaCadastroPessoasState();
}

class _TelaCadastroPessoasState extends State<TelaCadastroLocalTrabalho> {
  Estilo estilo = Estilo();
  int valorGenero = 0;
  int idItem = 0;
  bool retornoListaVazia = false;
  String tipoEscala = "";
  double alturaNavigationBar = 120.0;
  List<LocalTrabalho> localTrabalho = [];
  List<String> localSelecionados = [];
  final List<CheckBoxModel> itensCheckBox = [];
  final TextEditingController _controllerNome = TextEditingController(text: "");

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    consultarLocalTrabalho();
    // verificando qual a opcao selecionada na tela inicial
    // caso seja verdadeiro corresponde ao genero feminino
    // e falso corresponde ao genero masculino
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
      valorGenero = 1;
    } else {
      tipoEscala = Textos.btnCooperador;
      valorGenero = 0;
    }
    localSelecionados.add(Textos.localData);
    localSelecionados.add(Textos.localHoraTroca);
  }

  // metodo para inserir os dados no banco de dados
  inserirDados() async {
    // linha para incluir os dados
    Map<String, dynamic> linha = {
      BancoDeDados.columnLocal: _controllerNome.text,
    };
    await bancoDados.inserir(linha, Constantes.bancoTabelaLocalTrabalho);
    consultarLocalTrabalho();
  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarLocalTrabalho() async {
    // limpando listas
    itensCheckBox.clear();
    localTrabalho.clear();
    // chamando metodo responsavel por pegar os itens no banco de dados
    await Consulta.consultarBancoLocalTrabalho(
            Constantes.bancoTabelaLocalTrabalho)
        .then((value) {
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
        itensCheckBox.add(CheckBoxModel(
            texto: localTrabalho[i].nomeLocal, idItem: localTrabalho[i].id));
      }
      _controllerNome.text = ""; // definindo texto do campo
    });
  }

  // metodo para pegar os itens que foram selecionados no check box
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
                    bancoDados.excluir(id, Constantes.bancoTabelaLocalTrabalho);
                    consultarLocalTrabalho();
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
        activeColor: PaletaCores.corAzul,
        checkColor: PaletaCores.corAdtlLetras,
        secondary: SizedBox(
            width: 30,
            height: 30,
            child: FloatingActionButton(
              heroTag: "btnExcluirLocal ${checkBoxModel.idItem}",
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, size: 20),
              onPressed: () {
                exibirConfirmacaoExcluir(checkBoxModel.idItem);
              },
            )),
        title: Text(checkBoxModel.texto),
        side: const BorderSide(width: 2, color: Colors.black),
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
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaCadastroPessoas,
                  arguments: widget.genero);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaCadastroLocalTrabalho,
                    textAlign: TextAlign.center),
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
                                      Textos.descricaoCadastroLocalTrabalho,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return Textos
                                                        .erroTextFieldVazio;
                                                  }
                                                  return null;
                                                },
                                                controller: _controllerNome,
                                                decoration: InputDecoration(
                                                  labelText: Textos
                                                      .labelTextCadLocalTrabalho,
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 50,
                                          width: 150,
                                          child: ElevatedButton(
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
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.only(top: 10.0),
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
                                              height: alturaTela * 0.4,
                                              width: larguraTela * 0.9,
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
                              ))
                        ],
                      ))
                    ],
                  ),
                )),
              ),
              bottomNavigationBar: SizedBox(
                height: Constantes.alturaNavigationBar,
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
                          width: 60,
                          height: 60,
                          child: FloatingActionButton(
                            heroTag: "btnAvancarCadLocal",
                            backgroundColor: PaletaCores.corVerdeCiano,
                            onPressed: () {
                              pegarItensLocal();
                              if (localSelecionados.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(Textos.erroSemSelecaoCheck)));
                              } else {
                                var dados = {};
                                dados[Constantes.parametroGenero] =
                                    widget.genero;
                                dados[Constantes.parametroListaPessoas] =
                                    widget.listaPessoas;
                                dados[Constantes.parametroListaLocal] =
                                    localSelecionados;
                                Navigator.pushReplacementNamed(
                                    context, Constantes.rotaTelaSelecaoDias,
                                    arguments: dados);
                              }
                            },
                            child: const Icon(Icons.arrow_forward, size: 40),
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
                      height: 5,
                    ),
                    const SizedBox(height: 60, child: BarraNavegacao()),
                  ],
                ),
              ),
            )));
  }
}
