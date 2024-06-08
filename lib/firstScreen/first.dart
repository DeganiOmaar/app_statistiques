import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'api_service.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  final ApiService apiService = ApiService();
  List<dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      var result = await apiService.fetchDataFromNewAPI();
      setState(() {
        data = result['item'];
      });
    } catch (e) {
      // Gérer les erreurs
      print("Erreur lors de la récupération des données: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Par Heure", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: data!.map<BarChartGroupData>((item) {
                          int index = data!.indexOf(item);
                          double accidentsValue = double.tryParse(item['accidents']) ?? 0;
                          double tuesValue = double.tryParse(item['tues']) ?? 0;
                          double blessesValue = double.tryParse(item['blesses']) ?? 0;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: accidentsValue,
                                color: Colors.blue,
                              ),
                              BarChartRodData(
                                toY: tuesValue,
                                color: Colors.red,
                              ),
                              BarChartRodData(
                                toY: blessesValue,
                                color: Colors.green,
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData:  FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true, 
                         interval: 100,
                            reservedSize: 35,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value % 3 == 0) {
                                  final label = data![value.toInt()]['labelle'];
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 10.0, // marge en haut
                                    child: Text(label, style: const TextStyle(fontSize: 10)),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 35,
                          interval: 60
                          ),
                          ), 
                          topTitles:  const AxisTitles(
                            sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 35,
                          interval: 60
                          ),
                        ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Indicator(
                        color: Colors.blue,
                        text: 'Accidents',
                        isSquare: true,
                      ),
                      SizedBox(width: 10),
                      Indicator(
                        color: Colors.red,
                        text: 'Tues',
                        isSquare: true,
                      ),
                      SizedBox(width: 10),
                      Indicator(
                        color: Colors.green,
                        text: 'Blessures',
                        isSquare: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

