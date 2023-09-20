import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/model/Usuario.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class Database {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE USUARIOS(
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      NOME TEXT,
      USUARIO TEXT,
      VALOR DOUBLE,
      VENCIMENTO DATE,
      DESCRICAO TEXT,
      DETALHES TEXT
      )
    """);
  }

  static Future<sql.Database> db() async {
    final dbPath = await sql.getDatabasesPath();
    final path = join(dbPath, 'clientes.db');

    return sql.openDatabase(
      'clientes.db',
      version: 14,
      onCreate: (sql.Database database, int version) async {
        database.transaction((txn) async {
          await txn.execute("""
                          CREATE TABLE USUARIOS(
                          ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                          NOME TEXT,
                          USUARIO TEXT,
                          VALOR DOUBLE,
                          VENCIMENTO DATE,
                          DESCRICAO TEXT,
                          DETALHES TEXT
                          )
                          """);
          await txn.execute('''CREATE TABLE mes (
                          id_mes INTEGER PRIMARY KEY AUTOINCREMENT,
                          mes INTEGER,
                          total REAL
                          )''');
          await txn.execute('''CREATE TABLE ano (
                          id_ano INTEGER PRIMARY KEY AUTOINCREMENT,
                          ano INTEGER,
                          total REAL
                          )''');
          await txn.execute('''CREATE TABLE ano_mes (
                          id_ano REFERENCES ano (id_ano),
                          id_mes REFERENCES mes (id_mes) 
                          )''');
        });
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.transaction((txn) async {
          try {
            txn.execute("drop table ano_mes");
            txn.execute("drop table ano");
            txn.execute("drop table mes");

            txn.execute('''CREATE TABLE mes (
                          id_mes INTEGER PRIMARY KEY AUTOINCREMENT,
                          mes INTEGER,
                          total REAL
                          )''');
            txn.execute('''CREATE TABLE ano (
                          id_ano INTEGER PRIMARY KEY AUTOINCREMENT,
                          ano INTEGER,
                          total REAL
                          )''');
            txn.execute('''CREATE TABLE ano_mes (
                          id_ano REFERENCES ano (id_ano),
                          id_mes REFERENCES mes (id_mes) 
                          )''');
          } catch (e) {}
        });
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
