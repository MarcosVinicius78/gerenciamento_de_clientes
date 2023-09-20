import 'database.dart';

class DatabaseRelatorio {
  static void comandos() async {
    final db = await Database.db();

    db.transaction((txn) async {
      try {
        await txn.execute('delete from ano_mes');
        await txn.execute('delete from mes');
        await txn.execute('delete from ano');
        // await txn.execute('insert into ano (ano, total) values(2022,2000)');
        // await txn.execute('insert into mes (mes,total) values(1, 2000)');
        // // await txn.execute("insert into ano_mes (id_ano,id_mes) values(18,2)");

        // await txn.execute('delete from');
      } catch (e) {
        throw e;
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getAnos() async {
    final db = await Database.db();


    return db.rawQuery('select ano.id_ano, ano.ano from ano');
  }

  static Future<List<Map<String, dynamic>>> getTotalMes(int ano) async {
    final db = await Database.db();

    // int ano = DateTime.now().year;

    return db.rawQuery("""SELECT mes.id_mes, mes.mes,mes.total FROM ano
                          JOIN ano_mes ON ano.id_ano = ano_mes.id_ano
                               JOIN mes ON ano_mes.id_mes = mes.id_mes
                               WHERE ano.ano = ?;""", [ano]);
  }

  static Future<List<Map<String, Object?>>> mesEncontrad() async {
    final db = await Database.db();

    int ano = DateTime.now().year;
    int mes = DateTime.now().month;

    return db.rawQuery("""select mes.id_mes, mes.mes, mes.total from ano 
                  join ano_mes on ano.id_ano = ano_mes.id_ano
                  join mes on mes.id_mes = ano_mes.id_mes
                  where ano.ano = ? and mes.mes = ?
                """, [ano, mes]);
  }

  static Future<int> atualizarTotalMesEAno(double valor) async {
    final db = await Database.db();

    final List<Map<String, dynamic>> mesEncontrado;

    mesEncontrado = await mesEncontrad();

    if (mesEncontrado.isEmpty) {
      var ano = await db
          .query('ano', where: 'ano = ?', whereArgs: [DateTime.now().year]);

      if (ano.isEmpty) {
        var salvarAno = {'ano': DateTime.now().year, 'total': valor};

        db.insert('ano', salvarAno);
      }

      await db.rawQuery(
          'insert into mes (mes, total) values (?,?)',
          [DateTime.now().month, valor]);

      var id = await db.rawQuery('select MAX(mes.id_mes) from mes');
      print(id[0]['MAX(mes.id_mes)']);

      ano = await db
          .query('ano', where: 'ano = ?', whereArgs: [DateTime.now().year]);

      var anoMes = {
        'id_ano': ano[0]['id_ano'],
        'id_mes': id[0]['MAX(mes.id_mes)']
      };

      double soma = double.parse(ano[0]['total'].toString()) + valor;

      var anoAtualizado = {
        'id_ano': ano[0]['id_ano'],
        'ano': ano[0]['ano'],
        'total': soma
      };

      db.update('ano', anoAtualizado);

      return db.insert('ano_mes', anoMes);
    } else {
      final ano = await db
          .query('ano', where: 'ano = ?', whereArgs: [DateTime.now().year]);
      double soma = mesEncontrado[0]['total'] + valor;
      var anoAtualizado = {
        'id_ano': ano[0]['id_ano'],
        'ano': ano[0]['ano'],
        'total': soma
      };

      db.update('ano', anoAtualizado);
      int id = mesEncontrado[0]['id_mes'];
      Map<String, Object> mesAdicionar = {
        'id_mes': id,
        'mes': DateTime.now().month,
        'total': soma
      };
      return db.update('mes', mesAdicionar,
          where: 'id_mes = ?', whereArgs: [mesEncontrado[0]['id_mes']]);
    }
  }
}
