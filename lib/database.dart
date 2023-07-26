import 'package:gerenciamento_de_clientes/model/Usuario.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE USUARIOS(
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      NOME TEXT,
      USUARIO TEXT,
      VALOR DOUBLE,
      VENCIMENTO DATE,
      DESCRICAO TEXT)
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "clientes.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        createTables(db);
      },
    );
  }

  static Future<int> criarUsuario(UsuarioModel usuario) async {
    final dbUsuario = await Database.db();

    final id = await dbUsuario.insert('USUARIOS', usuario.toMap());

    return id;
  }

  static Future<List<Map<String, dynamic>>> listarUsuarios() async {
    final dbUsuario = await Database.db();

    // return dbUsuario.query('USUARIOS', groupBy: 'id');
    return dbUsuario
        .rawQuery('''SELECT * FROM USUARIOS ORDER BY VENCIMENTO ASC''');
  }

  static Future<int> apagarUsuario(int id) async {
    final dbUsuario = await Database.db();

    return dbUsuario.delete('USUARIOS', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> atualizarUsuario(Map<String, dynamic> usuario) async {
    final dbUsuario = await Database.db();

    int id = usuario['ID'];

    return dbUsuario
        .update('USUARIOS', usuario, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getUsuariosDevendo() async {
    final dbUsuarios = await Database.db();

    return dbUsuarios
        .query('USUARIOS', where: 'DESCRICAO = ?', whereArgs: ['DEVENDO']);
  }
}
