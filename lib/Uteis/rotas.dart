import 'package:flutter/material.dart';
import 'package:senturionglist/Telas/cadastro/tela_cadastro_pessoas.dart';
import 'package:senturionglist/Telas/selecao/tela_selecao_periodo.dart';
import 'package:senturionglist/Telas/tela_configuracoes.dart';
import 'package:senturionglist/Telas/tela_edicao_cadastro_item.dart';
import 'package:senturionglist/Telas/tela_gerar_escala.dart';
import 'package:senturionglist/Telas/tela_inicial.dart';
import 'package:senturionglist/Telas/tela_listagem.dart';
import 'package:senturionglist/Telas/selecao/tela_selecao_dias_semana.dart';
import 'package:senturionglist/Telas/cadastro/tela_cadastro_local_trabalho.dart';
import 'package:senturionglist/Telas/selecao/tela_selecao_escala.dart';
import 'package:senturionglist/Telas/tela_splash_screen.dart';
import 'constantes.dart';

class Rotas {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.
    final args = settings.arguments;
    switch (settings.name) {
      case Constantes.rotaTelaSplashScreen:
        return MaterialPageRoute(builder: (_) => const TelaSplashScreen());
      case Constantes.rotaTelaConfiguracoes:
        return MaterialPageRoute(builder: (_) => const TelaConfiguracoes());
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) => TelaInicial());
      case Constantes.rotaTelaSelecaoEscala:
        return MaterialPageRoute(builder: (_) => const TelaSelecaoEscala());
      case Constantes.rotaTelaCadastroPessoas:
        if (args is bool) {
          return MaterialPageRoute(
            builder: (_) => TelaCadastroPessoas(
              genero: args,
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaListagem:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => TelaListagem(
              nomeTabela: args,
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaCadastroLocalTrabalho:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaCadastroLocalTrabalho(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaSelecaoDias:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaSelecaoDiasSemana(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
              listaLocal: args[Constantes.parametroListaLocal],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaSelecaoPeriodo:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaSelecaoPeriodo(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
              listaLocal: args[Constantes.parametroListaLocal],
              listaDias: args[Constantes.parametroListaDias],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaGerarEscala:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaGerarEscala(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
              listaLocal: args[Constantes.parametroListaLocal],
              listaDias: args[Constantes.parametroListaDias],
              listaPeriodo: args[Constantes.parametroListaPeriodo],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaEdicao:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaEdicaoCadastroItem(
              camposBancoCadastroItem: args[Constantes.parametroEdicaoCadCamposBanco],
              nomeTabela: args[Constantes.parametroEdicaoCadNomeTabela],
              idItem: args[Constantes.parametroEdicaoCadIdItem],
            ),
          );
        } else {
          return erroRota(settings);
        }
    }
    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir tela de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Telas não encontrada!"),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text("Telas não encontrada."),
          ),
        ),
      );
    });
  }
}
