import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/database/database-relatorio.dart';
import 'package:gerenciamento_de_clientes/views/MyHomePage.dart';
import 'package:gerenciamento_de_clientes/database/database.dart';
import 'package:gerenciamento_de_clientes/model/Usuario.dart';
import 'package:intl/intl.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _MyWidgetState();
}

String dataEnviar = "";

class _MyWidgetState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropDescricao = ['PAGO', 'DEVENDO'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        data = DateFormat('dd-MM-yyyy').format(pickedDate);
        dataEnviar = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  String? _validarNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
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

  String nome = '';
  String usuario = '';
  double valor = 0;
  double lucro = 0;
  String data = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String descricao = "PAGO";
  String detalhes = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Cadastro"),
            backgroundColor: const Color.fromARGB(255, 32, 68, 115)),
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            color: const Color.fromARGB(255, 208, 236, 242),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Nome",
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: TextFormField(
                        onChanged: (newValue) {
                          nome = newValue;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Insira o nome";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Usuario",
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 255, 255, 255)),
                          child: TextFormField(
                              onChanged: (value) {
                                usuario = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Insira o Usuario";
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: InputBorder.none)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: const Text(
                              "Valor",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: "Futura"),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            margin: const EdgeInsets.only(left: 33, top: 10),
                            child: const Text(
                              "Lucro",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: "Futura"),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 255, 255, 255)),
                          child: TextFormField(
                              onChanged: (value) {
                                valor = double.parse(value);
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Insira o Valor";
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  prefixText: "R\$",
                                  border: InputBorder.none)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 255, 255, 255)),
                          child: TextFormField(
                              onChanged: (value) {
                                lucro = double.parse(value);
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Insira o lucro";
                                }
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  prefixText: "R\$",
                                  border: InputBorder.none)),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Vencimento",
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: TextFormField(
                          validator: (value) {
                            if (dataVencida(value.toString())) {
                              return "Coloque mais de 30 dias";
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: TextEditingController(text: data),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none)),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Status",
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        value: descricao,
                        items: dropDescricao
                            .map<DropdownMenuItem<String>>((String valor) {
                          return DropdownMenuItem(
                              value: valor,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(valor),
                              ));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            descricao = value.toString();
                          });
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Detalhes",
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: TextFormField(
                        onChanged: (newValue) {
                          detalhes = newValue;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 126, 140, 105))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                UsuarioModel user = UsuarioModel(
                                    nome: nome,
                                    usuario: usuario,
                                    valor: valor,
                                    lucro: lucro,
                                    vencimento: dataEnviar,
                                    descricao: descricao,
                                    detalhes: detalhes);
                                if (descricao == 'PAGO') {
                                  DatabaseRelatorio.atualizarTotalMesEAno(
                                      lucro);
                                }
                                print(user.lucro);
                                Database.criarUsuario(user);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Salvar")),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
