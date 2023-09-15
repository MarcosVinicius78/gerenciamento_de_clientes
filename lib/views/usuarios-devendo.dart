import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gerenciamento_de_clientes/database.dart';

import 'editar-usuario.dart';

class Usuariosdevendo extends StatefulWidget {
  const Usuariosdevendo({super.key});

  @override
  State<Usuariosdevendo> createState() => _UsuariosdevendoState();
}

class _UsuariosdevendoState extends State<Usuariosdevendo> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    carregarUsuariosDevendo();
    super.initState();
  }

  void carregarUsuariosDevendo() async {
    final usuariosDevendo = await Database.getUsuariosDevendo();
    setState(() {
      usuarios = usuariosDevendo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios Devendo"),
        backgroundColor: Colors.black,
      ),
      body: usuarios.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: const Text("NENHUM CLIENTE DEVENDO"))
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditarUsuario(model: usuarios[index]),
                        )).then((value) => {carregarUsuariosDevendo()});
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(usuarios[index]['NOME']),
                          Text(usuarios[index]['USUARIO']),
                          Text(usuarios[index]['VALOR'].toString()),
                        ],
                      ),
                    ),
                  )),
            ),
    );
  }
}
