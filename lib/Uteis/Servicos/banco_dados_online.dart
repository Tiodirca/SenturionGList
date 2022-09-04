import 'package:mysql1/mysql1.dart';

class BancoDadosOnline {
  static var criarConexaoBanco = ConnectionSettings(
      host: 'localhost', port: 3306, user: 'root', db: 'testedb');

  static Future<bool> criarTabelaOnline(
      String queryCriarTabela, String nomeTabela) async {
    // abrindo conexao
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    try {
      await conexao.query(
          'CREATE TABLE IF NOT EXIST $nomeTabela (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, $queryCriarTabela)');
      await conexao.close();
      return true;
    } catch (e) {
      print(e);
      await conexao.close();
      return false;
    }
    // // Insert some data
    // var result = await conn.query(
    //     'insert into users (name, email, age) values (?, ?, ?)',
    //     ['Bob', 'bob@bob.com', 25]);
    // print('Inserted row id=${result.insertId}');
    //
    // // Query the database using a parameterized query
    // var results = await conn.query(
    //     'select name, email, age from users where id = ?', [result.insertId]);
    // for (var row in results) {
    //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    // }
    //
    // // Update some data
    // await conn.query('update users set age=? where name=?', [26, 'Bob']);
    //
    // // Query again database using a parameterized query
    // var results2 = await conn.query(
    //     'select name, email, age from users where id = ?', [result.insertId]);
    // for (var row in results2) {
    //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    // }
  }

  static Future inserirDadosOnline(
      String tabela, String query) async {
    // abrindo conexao
    var conexao = await MySqlConnection.connect(criarConexaoBanco);
    // Insert some data
    var result = await conexao.query(
        'insert into $tabela (Data, Horario_de_Troca) values (?, ?)',
        ['fdfsf', '18>4543']);
    print('Inserted row id=${result.insertId}');
  }
}
