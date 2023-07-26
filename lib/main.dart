import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/views/Cadastro.dart';
import 'package:gerenciamento_de_clientes/views/editar-usuario.dart';

import 'views/MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
