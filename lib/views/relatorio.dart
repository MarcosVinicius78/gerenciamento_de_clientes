import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gerenciamento_de_clientes/database/database-relatorio.dart';
import 'package:gerenciamento_de_clientes/database/database.dart';

class Relatorio extends StatefulWidget {
  const Relatorio({super.key});

  @override
  State<Relatorio> createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  int selectedYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  List<String> anos = [];

  @override
  void initState() {
    getAno();
    carregarTotalMes(DateTime.now().year);
    super.initState();
  }

  void getAno() async {
    final anos = await DatabaseRelatorio.getAnos();

    setState(() {
      anos.forEach((element) {
        this.anos.add(element['ano'].toString());
      });
    });
  }

  late double total = 0;
  void carregarTotalMes(int ano) async {
    final totalMes = await DatabaseRelatorio.getTotalMes(ano);

    setState(() {
      totalMes.forEach((element) {
        double mes = double.parse(element['mes'].toString());

        Map<String, double> valor = {'mes': mes, 'total': element['total']};

        data.add(valor);

        if (element['mes'] == DateTime.now().month) {
          total = element['total'];
        }
      });
    });
  }

  List<Map<String, double>> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatorio"),
        backgroundColor: const Color.fromARGB(255, 32, 68, 115),
      ),
      body: Container(
        color: const Color.fromARGB(255, 208, 236, 242),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 200,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 11, 43, 64),
              ),
              child: BarChart(
                BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        showTitles: false,
                      ),
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTextStyles: (context, value) {
                          return const TextStyle(color: Colors.white);
                        },
                        getTitles: (value) {
                          return value.toInt().toString();
                        },
                      ),
                    ),
                    minY: 10,
                    maxY: 1000,
                    barGroups: data.asMap().entries.map((e) {
                      return BarChartGroupData(
                          x: e.value['mes']!.toInt(),
                          barRods: [
                            BarChartRodData(
                                y: e.value['total']!.toDouble(),
                                colors: [
                                  const Color.fromARGB(255, 255, 255, 255)
                                ])
                          ]);
                    }).toList()),
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, spreadRadius: 1, blurRadius: 3),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 255, 255, 255)),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text("Saldo do mes: $total",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0)))),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                isExpanded: true,
                value: DateTime.now().year.toString(),
                items: anos.map<DropdownMenuItem<String>>((String valor) {
                  return DropdownMenuItem(
                      value: valor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(valor.toString()),
                      ));
                }).toList(),
                onChanged: (value) {
                  carregarTotalMes(int.parse(value!));
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: Color.fromARGB(255, 32, 68, 115),
                ),
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Container(
                          height: 50,
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(data[index]['mes'].toString()),
                              Text(data[index]['total'].toString())
                            ],
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
