import 'package:flutter/material.dart';
import 'package:gerenciamento_de_clientes/database.dart';
import 'package:gerenciamento_de_clientes/model/Usuario.dart';
import 'package:gerenciamento_de_clientes/views/MyHomePage.dart';
import 'package:intl/intl.dart';

class EditarUsuario extends StatefulWidget {
  final Map<String, dynamic> model;

  const EditarUsuario({super.key, required this.model});

  @override
  State<EditarUsuario> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditarUsuario> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropDescricao = ['PAGO', 'DEVENDO'];
  bool readOnly = true;
  late TextEditingController nome = TextEditingController(text: "");
  late TextEditingController usuario = TextEditingController(text: "");
  late TextEditingController valor = TextEditingController(text: "");
  late TextEditingController vencimento = TextEditingController(text: "");
  String descricao = "PAGO";

  @override
  void initState() {
    nome = TextEditingController(text: widget.model['NOME']);
    usuario = TextEditingController(text: widget.model['USUARIO']);
    valor = TextEditingController(text: widget.model['VALOR'].toString());
    vencimento = TextEditingController(text: converterData());
    descricao = widget.model['DESCRICAO'];
    vencimentoSelecionando = widget.model['VENCIMENTO'];
  }

  String vencimentoSelecionando = "";
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        vencimento.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        vencimentoSelecionando = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  String converterData() {
    List<String> userPartes = widget.model['VENCIMENTO'].toString().split('-');

    int ano = int.parse(userPartes.elementAt(0));
    int mes = int.parse(userPartes.elementAt(1));
    int dia = int.parse(userPartes.elementAt(2));

    DateTime data = DateTime(ano, mes, dia);

    return DateFormat('dd-MM-yyyy').format(data);
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

  void atualizarUsuario() {
    final usuarioMap = {
      'ID': widget.model['ID'],
      'NOME': nome.text,
      'USUARIO': usuario.text,
      'VALOR': valor.text,
      'VENCIMENTO': vencimentoSelecionando,
      'DESCRICAO': descricao
    };

    if (_formKey.currentState!.validate()) {
      Database.atualizarUsuario(usuarioMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Editando"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
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
                        color: Color.fromARGB(255, 222, 222, 222)),
                    child: TextFormField(
                      onChanged: (newValue) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Insira o nome";
                        }
                        return null;
                      },
                      readOnly: readOnly,
                      controller: nome,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.575,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 222, 222, 222)),
                          child: TextFormField(
                              readOnly: readOnly,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Insira o Usuario";
                                }
                              },
                              controller: usuario,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: InputBorder.none)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 222, 222, 222)),
                        child: TextFormField(
                            readOnly: readOnly,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Insira o Valor";
                              }
                            },
                            controller: valor,
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
                        color: Color.fromARGB(255, 222, 222, 222)),
                    child: TextFormField(
                      validator: (value) {
                        if (dataVencida(value.toString())) {
                          return "Coloque mais de 30 dias";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none),
                      readOnly: true,
                      onTap: () {
                        if (readOnly == false) {
                          _selectDate(context);
                        }
                      },
                      controller: vencimento,
                    ),
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
                        color: Color.fromARGB(255, 222, 222, 222)),
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
                        if (readOnly != true) {
                          setState(() {
                            descricao = value.toString();
                          });
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          readOnly == true
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      readOnly = false;
                                    });
                                  },
                                  child: const Text("Editar"))
                              : SizedBox(
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              atualizarUsuario();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Salvar")),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                readOnly = true;
                                              });
                                            },
                                            child: const Text("Cancelar")),
                                      )
                                    ],
                                  ),
                                ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
