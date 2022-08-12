import 'package:senturionglist/Modelo/local_trabalho.dart';

import '../../Modelo/pessoa.dart';
import '../constantes.dart';
import 'banco_de_dados.dart';

class Consulta {
  // referencia classe para gerenciar o banco de dados
  static BancoDeDados bancoDados = BancoDeDados.instance;

  //metodo para realizar a consulta no banco de dados
  static Future<List<Pessoa>> consultarBancoPessoas(String tabela) async {
    final registros = await bancoDados.consultarLinhas(tabela);
    List<Pessoa> lista = [];
    for (var linha in registros) {
      bool genero;
      if (linha[Constantes.columnPessoaGenero].toString().contains("0")) {
        // falso para homens
        genero = false;
      } else {
        //true para mulheres
        genero = true;
      }
      lista.add(Pessoa(
          id: linha[Constantes.columnId],
          nome: linha[Constantes.columnPessoaNome],
          genero: genero));
    }
    return lista;
  }

  //metodo para realizar a consulta no banco de dados
  static Future<List<LocalTrabalho>> consultarBancoLocalTrabalho(
      String tabela) async {
    final registros = await bancoDados.consultarLinhas(tabela);
    List<LocalTrabalho> lista = [];
    for (var linha in registros) {
      lista.add(LocalTrabalho(
          id: linha[Constantes.columnId],
          nomeLocal: linha[Constantes.columnLocal]));
    }
    return lista;
  }

  //metodo para realizar a consulta no banco de dados
  static Future<List<Map<String, dynamic>>> consultarTabelaSelecionada(
      String tabela) async {
    final registros = await bancoDados.consultarLinhas(tabela);
    List<Map<String, dynamic>> lista = [];
    for (var linha in registros) {
      lista.add(linha);
    }
    return lista;
  }
}
