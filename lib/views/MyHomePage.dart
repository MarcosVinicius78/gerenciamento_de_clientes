import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/database.dart';
import 'package:gerenciamento_de_clientes/views/editar-usuario.dart';

import 'Cadastro.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> usuariosDevendo = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
    usuariosDevend();
  }

  Future<dynamic> desejaApagar(context) async {
    final apagar = showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Deseja Apagar?", textAlign: TextAlign.center),
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Sim")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Não"))
              ],
            )
          ],
        );
      },
    );

    return apagar;
  }

  void usuariosDevend() async {
    final userDevendo = await Database.getUsuariosDevendo();

    setState(() {
      usuariosDevendo = userDevendo;
    });
  }

  void carregarUsuarios() async {
    final users = await Database.listarUsuarios();
    setState(() {
      usuarios = users;
    });
  }

  bool dataVencida(String user) {
    List<String> userPartes = user.split('-');

    int dia = int.parse(userPartes.elementAt(0));
    int mes = int.parse(userPartes.elementAt(1));
    int ano = int.parse(userPartes.elementAt(2));

    DateTime data = DateTime(ano, mes, dia);

    if (data.isBefore(DateTime.now()) ||
        data.isAtSameMomentAs(DateTime.now())) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Clientes'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width * 0.95,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 12, 12, 12)),
            child: CarouselSlider(
                items: usuariosDevendo.map((usuarios) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarUsuario(
                                    model: usuarios,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(usuarios['NOME']),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(usuarios['USUARIO']),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(usuarios['VALOR'].toString()),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(usuarios['VENCIMENTO']),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(dataVencida(usuarios['VENCIMENTO'])
                                    ? "NÃO RENOVADO"
                                    : usuarios['DESCRICAO']),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    autoPlayCurve: Curves.easeInSine,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3))),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: usuarios.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: const Text(
                        "SEM CLIENTES",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ))
                  : ListView.builder(
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Card(
                          color: const Color.fromARGB(255, 236, 236, 236),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(usuarios[index]['NOME']),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                                usuarios[index]['USUARIO'])),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(usuarios[index]['VALOR']
                                              .toString()),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 0),
                                            child: Text(
                                                usuarios[index]['VENCIMENTO']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: dataVencida(
                                                            usuarios[index]
                                                                ['VENCIMENTO'])
                                                        ? Colors.red
                                                        : Colors.green)),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(dataVencida(
                                                    usuarios[index]
                                                        ['VENCIMENTO'])
                                                ? "NÃO RENOVADO"
                                                : usuarios[index]['DESCRICAO']
                                                    .toString()),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (await desejaApagar(context)) {
                                        int id = usuarios[index]['ID'];
                                        Database.apagarUsuario(id);
                                        carregarUsuarios();
                                        usuariosDevend();
                                      } else {}
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarUsuario(model: usuarios[index]),
                                  ))
                              .then((value) =>
                                  {carregarUsuarios(), usuariosDevend()});
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Cadastro(),
              )).then((value) => {usuariosDevend(), carregarUsuarios()});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
