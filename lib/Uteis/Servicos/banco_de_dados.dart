import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constantes.dart';

class BancoDeDados {
  static const bancoDadosNome = Constantes.bancoNomeBanco;
  static const bancoDadosVersao = 1;
  static const tabelaPessoa = Constantes.bancoTabelaPessoa;
  static const tabelaLocalTrabalho = Constantes.bancoTabelaLocalTrabalho;
  static const columnId = Constantes.columnId;
  static const columnPessoaNome = Constantes.columnPessoaNome;
  static const columnPessoaGenero = Constantes.columnPessoaGenero;
  static const columnLocal = Constantes.columnLocal;

  // torna a clase singleton
  BancoDeDados._privateConstructor();

  static final BancoDeDados instance = BancoDeDados._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //String path = join(documentsDirectory.path, bancoDadosNome);
    // Init ffi loader if needed.
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            onCreate: _onCreate, version: bancoDadosVersao));
    //return await openDatabase(path,
    //  version: bancoDadosVersao, onCreate: _onCreate);
    return db;
  }

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tabelaPessoa(
            $columnId INTEGER PRIMARY KEY,
            $columnPessoaNome TEXT NOT NULL,
            $columnPessoaGenero BIT NOT NULL)
          ''');
    await db.execute('''
          CREATE TABLE $tabelaLocalTrabalho(
            $columnId INTEGER PRIMARY KEY,
            $columnLocal TEXT NOT NULL)
          ''');
  }

  // metodo para criar tabela de listagem de forma dinamica
  Future<void> criarTabela(String querySQL, String tabela) async {
    return await _database!.execute('''
          CREATE TABLE $tabela($querySQL)
          ''');
  }

  Future<List<Map<String, Object?>>> consultaTabela() async {
    Database? db = await instance.database;
    return await db!.rawQuery("SELECT * FROM sqlite_master WHERE type='table'");
  }

  // métodos auxiliares
  // metodo para inserir dados no banco
  // uma linha e inserida onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  Future<int> inserir(Map<String, dynamic> row, String tabela) async {
    Database? db = await instance.database;
    return await db!.insert(tabela, row);
  }

  // metodo para realizr a consuta no banco de dados de todas as linhas
  // elas são retornadas como uma lista de mapas
  Future<List<Map<String, dynamic>>> consultarLinhas(String tabela) async {
    Database? db = await instance.database;
    return await db!.query(tabela);
  }

  // metodo para atualizar os dados
  // a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> atualizar(Map<String, dynamic> row, String tabela) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(tabela, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // metodo para excluir a linha especificada pelo id.
  Future<int> excluir(int id, String tabela) async {
    Database? db = await instance.database;
    return await db!.delete(tabela, where: '$columnId = ?', whereArgs: [id]);
  }
}
