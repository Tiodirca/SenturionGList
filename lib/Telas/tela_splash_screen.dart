import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionglist/Widget/tela_carregamento.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Uteis/Servicos/banco_dados_online.dart';
import '../Uteis/Servicos/banco_de_dados_offline.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  List<Map<dynamic, dynamic>> valoresTabelaOnline = [];
  List<String> colunasBanco = [];
  List<String> tabelasBancoOnline = [];
  List<String> tabelasBancoLocal = [];
  final bancoDadosLocal = BancoDeDadosLocal.instance;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    });
    consultarTabelasBancoOnline();
    consultarTabelasBancoLocal();
    gravarDadosPadrao();

    //criarTabelaOnline();
  }

  // metodo para fazer consulta no banco de dados online e recuperar todas as tabelas
  // presente no banco de dados
  consultarTabelasBancoOnline() async {
    await BancoDadosOnline.consultarTabelas()
        .then((valor) => tabelasBancoOnline = valor);
  }

  // metodo para fazer consulta ao banco de dados local e recuperar todas as tabelas
  // presente no banco de dados offline
  consultarTabelasBancoLocal() async {
    final tabelasRecuperadas = await bancoDadosLocal.consultaTabela();
    setState(() {
      // pegando todos os elementos da lista e removendo aqueles que nao sao necessarios
      for (var linha in tabelasRecuperadas) {
        tabelasBancoLocal.removeWhere((element) =>
            element.toString().contains(Constantes.bancoTabelaLocalTrabalho) ||
            element.toString().contains("android_metadata") ||
            element.toString().contains(Constantes.bancoTabelaPessoa));
      }
    });

    if (tabelasBancoLocal.isEmpty) {
      print("Sem Tabelas");
      for (var elemento in tabelasBancoOnline) {
        String nomeTabela = elemento.replaceAll("[", "").replaceAll("]", "");
        chamarConsultaValoresTabelaBancoOnline(nomeTabela);
      }
    } else {
      print("Com tabelas");
    }
  }

  // metodo para chamar a consulta dos valores presente na tabela
  chamarConsultaValoresTabelaBancoOnline(String tabela) async {
    await BancoDadosOnline.consultarTodosValores(tabela)
        .then((value) => setState(() {
              valoresTabelaOnline = value;
            }));
    chamarCriarTabelasBancoLocal(tabela);
  }

  // metodo para criar tabelas no banco de dados local
  chamarCriarTabelasBancoLocal(String tabela) async {
    String querySQL = "";
    // pegando as colunas da tabela recuperada do banco online
    for (int i = 0; i < valoresTabelaOnline.first.keys.length; i++) {
      colunasBanco.add(valoresTabelaOnline.first.keys.elementAt(i));
    }
    // montando query SQL usando os elementos adicionados na lista
    for (var element in colunasBanco) {
      querySQL = "$querySQL $element TEXT NOT NULL,";
    }
    // chamando metodos
    bancoDadosLocal.criarTabela(
        querySQL.substring(0, querySQL.length - 1), tabela);
    inserirValoresTabelasBancoLocal(tabela);
    // limpando listas
    valoresTabelaOnline.clear();
    colunasBanco.clear();
  }

  // metodo para inserir os valores recuperados das tabelas online
  // nas tabelas do banco local
  inserirValoresTabelasBancoLocal(String tabela) {
    for (var valor in valoresTabelaOnline) {
      Map<String, dynamic> linha = {};
      for (int interacao = 0; interacao < colunasBanco.length; interacao++) {
        linha[colunasBanco[interacao]] =
            valor.values.elementAt(interacao).toString();
      }
      print(linha);
      bancoDadosLocal.inserir(linha, tabela);
    }
  }

  gravarDadosPadrao() async {
    //metodo para gravar informacoes padroes no share preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final horaMudada = prefs.getString('horaMudada') ?? '';
    if (horaMudada != "sim") {
      prefs.setString(Constantes.primeiroHorarioSemana,
          Constantes.horarioPrimeiroSemanaPadrao);
      prefs.setString(Constantes.segundoHorarioSemana,
          Constantes.horarioSegundoSemanaPadrao);
      prefs.setString(Constantes.primeiroHorarioFinalSemana,
          Constantes.horarioPrimeiroFinalSemanaPadrao);
      prefs.setString(Constantes.segundoHorarioFinalSemana,
          Constantes.horarioSegundoFinalSemanaPadrao);
    }
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return Scaffold(
      body: Container(
          height: alturaTela - alturaBarraStatus - alturaAppBar,
          width: larguraTela,
          color: PaletaCores.corAzul,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                FundoTela(
                    altura: alturaTela - alturaBarraStatus - alturaAppBar),
                Positioned(
                    child: SizedBox(
                        width: larguraTela,
                        height: alturaTela - alturaBarraStatus - alturaAppBar,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: larguraTela * 0.9,
                              height: alturaTela * 0.2,
                              child: Image.asset(
                                "assets/imagens/logo_app.png",
                              ),
                            ),
                            const TelaCarregamento()
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
