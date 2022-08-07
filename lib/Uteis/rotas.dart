import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senturionglist/Telas/tela_selecao_dias.dart';
import 'package:senturionglist/Telas/tela_cadastro_local_trabalho.dart';
import 'package:senturionglist/Telas/tela_selecao_intervalo.dart';

import '../Telas/tela_cadastro_pessoas.dart';
import '../Telas/tela_inicial.dart';
import 'constantes.dart';

class Rotas {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Constantes.rotaTelaInicial:
        return MaterialPageRoute(builder: (_) =>  const TelaInicial());
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
            builder: (_) => TelaSelecaoDias(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
              listaLocal: args[Constantes.parametroListaLocal],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case Constantes.rotaTelaSelecaoIntervalo:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaSelecaoIntervalo(
              genero: args[Constantes.parametroGenero],
              listaPessoas: args[Constantes.parametroListaPessoas],
              listaLocal: args[Constantes.parametroListaLocal],
              listaDias: args[Constantes.parametroListaDias],
            ),
          );
        } else {
          return erroRota(settings);
        }
      // case Constantes.telaTarefaSecretaFavorito:
      //   if (args is String) {
      //     return MaterialPageRoute(
      //       builder: (_) => TelaTarefaSecretaFavorito(
      //         tipoExibicao: args,
      //       ),
      //     );
      //   }else {
      //     return erroRota(settings);
      //   }
      // case Constantes.telaTarefaAdicao:
      //  return MaterialPageRoute(builder: (_) => const TelaAdionarTarefa());
      // case Constantes.telaTarefaDetalhada:
      //   if (args is Map) {
      //     return MaterialPageRoute(
      //       builder: (_) => TarefaDetalhada(
      //         item: args[Constantes.parametroDetalhesTarefa],
      //         comandoTelaLixeira: args[Constantes.parametroDetalhesComando],
      //       ),
      //     );
      //   } else {
      //     return erroRota(settings);
      //   }

    }

    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir mensagem de erro
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
