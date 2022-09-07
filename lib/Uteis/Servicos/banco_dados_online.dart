import 'package:mysql1/mysql1.dart';

class BancoDadosOnline {
  static var criarConexaoBanco = ConnectionSettings(
      host: 'localhost', port: 3306, user: 'root', db: 'testedb');

  static Future<List<String>> consultarTabelas() async {
    List<String> lista = [];
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    var resultado = await conexao.query('show tables');

    for (var linha in resultado) {
      lista.add(linha.values.toString());
    }
    conexao.close();
    return lista;
  }


  // _-------------------- METODOS
  // future para criar tabelas no banco de dados online
  static Future<bool> criarTabelaOnline(
      String queryCriarTabela, String nomeTabela) async {
    // abrindo conexao
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    try {
      await conexao.query(
          'CREATE TABLE IF NOT EXISTS $nomeTabela (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, $queryCriarTabela)');
      await conexao.close();
      return true;
    } catch (e) {
      print(e);
      await conexao.close();
      return false;
    }
  }

  // future para inserir dados no banco de dados online
  static Future<void> inserirDadosOnline(
      String tabela, String query, List<String> valores) async {
    // pegando as colunas da tabela
    String colunasTabela = query.replaceAll("TEXT NOT NULL", "");
    int tamanhoQuantiValores = valores.length; // pegando a quantidade de
    // valores a serem inseridos
    String valoresParametro = "";
    for (int i = 0; i < tamanhoQuantiValores; i++) {
      valoresParametro = "$valoresParametro ?,";
    }
    // abrindo conexao
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    // inserindo dados na tabela
    var resultado = await conexao.query(
        'INSERT INTO $tabela ($colunasTabela) VALUES (${valoresParametro.substring(0, valoresParametro.length - 1)})',
        valores);
    print('Linha Inserida =${resultado.insertId}');

    conexao.close();
  }

  // future para consultar todos os valores presente na tabela no banco de dados online
  static Future<List<Map<String, dynamic>>> consultarTodosValores(
      String tabela) async {
    List<Map<String, dynamic>> lista = [];
    // // abrindo conexao
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    var resultado = await conexao.query('SELECT * FROM $tabela');

    // pegando cada linha do resultado e adicionando em uma  lista
    // para ser retornado
    for (var linha in resultado) {
      linha.fields.removeWhere((key, value) => key == 'id');
      lista.add(linha.fields);
    }

    conexao.close();
    return lista;
  }
}
