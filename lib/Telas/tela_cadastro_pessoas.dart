import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/pessoa.dart';

import '../Modelo/check_box_modelo.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/Servicos/consulta.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaCadastroPessoas extends StatefulWidget {
  const TelaCadastroPessoas({Key? key, required this.genero})
      : super(key: key);

  final bool genero;

  @override
  State<TelaCadastroPessoas> createState() => _TelaCadastroPessoasState();
}

class _TelaCadastroPessoasState extends State<TelaCadastroPessoas> {
  int valorGenero = 0;
  int idItem = 0;
  bool retornoListaVazia = false;
  String tipoEscala = "";
  List<Pessoa> pessoas = [];
  List<String> listaPessoasSelecionados = [];
  double alturaNavigationBar = 120.0;
  final List<CheckBoxModel> itensCheckBox = [];
  final TextEditingController _controllerNomePessoa =
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
    if (widget.genero) {
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
      BancoDeDados.columnPessoaNome: _controllerNomePessoa.text,
      BancoDeDados.columnPessoaGenero: valorGenero
    };
    await bancoDados.inserir(linha, Constantes.bancoTabelaPessoa);
    consultarTarefas();
  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarTarefas() async {
    // limpando listas
    itensCheckBox.clear();
    pessoas.clear();
    // chamando metodo responsavel por pegar os itens no banco de dados
    await Consulta.consultarBancoPessoas(Constantes.bancoTabelaPessoa)
        .then((value) {
      setState(() {
        pessoas = value;
        // caso a lista retornada nao seja vazia executar comandos abaixo
        if (value.isNotEmpty) {
          // removendo itens da lista conforme os valores contidos nos parametros passados
          pessoas.removeWhere((item) =>
              (item.genero == true && widget.genero == false) ||
              item.genero == false && widget.genero == true);
          // verificando se a lista nao esta vazia
          if (pessoas.isNotEmpty) {
            adicionarItensCheckBox();
            retornoListaVazia = false;
          } else {
            retornoListaVazia = true;
          }
        } else {
          retornoListaVazia = true;
        }
      });
    });
  }

  // metodo para adicionar itens ao widget de check box
  adicionarItensCheckBox() {
    setState(() {
      for (int i = 0; i < pessoas.length; i++) {
        itensCheckBox
            .add(CheckBoxModel(texto: pessoas[i].nome, idItem: pessoas[i].id));
      }
      _controllerNomePessoa.text = ""; // definindo texto do campo
    });
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

  // metodo para pegar os itens que foram selecionados no check box
  pegarItensPessoas() {
    for (var element in itensCheckBox) {
      if (element.checked == true) {
        listaPessoasSelecionados.add(element.texto);
      }
    }
  }

  Widget checkBoxPersonalizado(CheckBoxModel checkBoxModel) => CheckboxListTile(
        activeColor: PaletaCores.corAzul,
        checkColor: PaletaCores.corAdtlLetras,
        secondary: SizedBox(
            width: 30,
            height: 30,
            child: FloatingActionButton(
              heroTag: "btnExcluir",
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
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(Textos.nomeTelaCadastroPessoas,
                textAlign: TextAlign.center),
            backgroundColor: PaletaCores.corAdtl,
            elevation: 0,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: SizedBox(
                width: larguraTela,
                height: alturaTela - alturaBarraStatus - alturaAppBar - alturaNavigationBar,
                child: Stack(
                  children: [
                    // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                    FundoTela(
                        altura: alturaTela -
                            alturaBarraStatus -
                            alturaAppBar -
                            alturaNavigationBar),
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
                                  const SizedBox(
                                    height: 10,
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
                                              controller: _controllerNomePessoa,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      Textos.labelTextCadPessoa,
                                                  fillColor: Colors.white,
                                                  labelStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 2,
                                                            color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  //definindo estilo do textfied ao ser clicado
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
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
                                  ),
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
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: alturaNavigationBar,
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
                        onPressed: () {
                          pegarItensPessoas();
                          if (listaPessoasSelecionados.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(Textos.erroSemSelecaoCheck)));
                          } else {
                            var dados = {};
                            dados[Constantes.parametroGenero] =
                                widget.genero;
                            dados[Constantes.parametroListaPessoas] =
                                listaPessoasSelecionados;
                            Navigator.pushReplacementNamed(context,
                                Constantes.rotaTelaCadastroLocalTrabalho,
                                arguments: dados);
                          }
                        },
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
          backgroundColor: Colors.white,
        ));
  }
}
