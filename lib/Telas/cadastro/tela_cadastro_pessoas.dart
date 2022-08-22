import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/check_box_modelo.dart';
import 'package:senturionglist/Modelo/pessoa.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';
import 'package:senturionglist/Uteis/Servicos/consultas.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/remover_acentos.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widget/barra_navegacao.dart';
import 'package:senturionglist/Widget/fundo_tela_widget.dart';

class TelaCadastroPessoas extends StatefulWidget {
  const TelaCadastroPessoas({Key? key, required this.genero}) : super(key: key);

  final bool genero;

  @override
  State<TelaCadastroPessoas> createState() => _TelaCadastroPessoasState();
}

class _TelaCadastroPessoasState extends State<TelaCadastroPessoas> {
  Estilo estilo = Estilo();
  int valorGenero = 0;
  int idItem = 0;
  bool retornoListaVazia = false;
  bool nomeExiste = false;
  String tipoEscala = "";
  List<Pessoa> pessoas = [];
  List<String> listaPessoasSelecionados = [];
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
    consultarPessoas();
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

  pegarTextoDigitado() {
    String texto = RemoverAcentos.removerAcentos(_controllerNomePessoa.text);
    return texto;
  }

  // metodo para inserir os dados no banco de dados
  inserirDados() async {
    if (RemoverAcentos.verificarCaracteresEspeciais(pegarTextoDigitado())) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Textos.erroCaracteresEspeciais)));
    } else {
      // linha para incluir os dados
      Map<String, dynamic> linha = {
        BancoDeDados.columnPessoaNome: pegarTextoDigitado(),
        BancoDeDados.columnPessoaGenero: valorGenero
      };
      int id = await bancoDados.inserir(linha, Constantes.bancoTabelaPessoa);
      if (id.toString().isNotEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(Textos.sucessoAddBanco)));
      }
      consultarPessoas();
    }
  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarPessoas() async {
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
                    consultarPessoas();
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
              heroTag: "btnExcluirPessoa ${checkBoxModel.idItem}",
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, size: 20),
              onPressed: () {
                exibirConfirmacaoExcluir(checkBoxModel.idItem);
              },
            )),
        title: Text(checkBoxModel.texto,
            style: const TextStyle(
                fontSize: Constantes.tamanhoLetraDescritivas,
                fontWeight: FontWeight.bold)),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
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
                  context, Constantes.rotaTelaInicial);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaCadastroPessoas,
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
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  width: larguraTela,
                                  child: Column(
                                    children: [
                                      Text(
                                        Textos.descricaoCadastroPessoas,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: Constantes
                                              .tamanhoLetraDescritivas,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
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
                                                  controller:
                                                      _controllerNomePessoa,
                                                  decoration: InputDecoration(
                                                    labelText: Textos
                                                        .labelTextCadPessoa,
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 50,
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_chaveFormulario
                                                    .currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    for (var value
                                                        in itensCheckBox) {
                                                      if (value.texto ==
                                                          pegarTextoDigitado()) {
                                                        nomeExiste = true;
                                                      }
                                                    }
                                                    if (nomeExiste == true) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(Textos
                                                                  .erroNomeExiste)));
                                                      nomeExiste = false;
                                                    } else {
                                                      nomeExiste = false;
                                                      inserirDados();
                                                    }
                                                  });
                                                }
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
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        Textos.legLista,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: Constantes
                                                .tamanhoLetraDescritivas,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
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
                        Theme(
                          data: estilo.botoesBarraNavegacao,
                          child: SizedBox(
                            width: Constantes.larguraBotoesBarraNavegacao,
                            height: Constantes.alturaBotoesNavegacao,
                            child: ElevatedButton(
                              onPressed: () {
                                pegarItensPessoas();
                                if (listaPessoasSelecionados.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              Textos.erroSemSelecaoCheck)));
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
                              child: const Icon(Icons.arrow_forward,
                                  size: Constantes.tamanhoIconeBotoesNavegacao),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          width: larguraTela * 0.3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              Textos.txtTipoEscala + tipoEscala,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
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
