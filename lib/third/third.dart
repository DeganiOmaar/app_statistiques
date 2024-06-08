import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

class AccidentData {
  final String labelle;
  final int accidents;
  final int tues;
  final int blesses;

  AccidentData({
    required this.labelle,
    required this.accidents,
    required this.tues,
    required this.blesses,
  });

  factory AccidentData.fromJson(Map<String, dynamic> json) {
    return AccidentData(
      labelle: json['labelle'] ?? '',
      accidents: int.parse(json['accidents'] ?? '0'),
      tues: int.parse(json['tues'] ?? '0'),
      blesses: int.parse(json['blesses'] ?? '0'),
    );
  }
}

class BarChartSample extends StatelessWidget {
  final AccidentData accidentData;

  BarChartSample({required this.accidentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 400, // Set a fixed height for each chart
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(toY: accidentData.accidents.toDouble(), color: Colors.blue, width: 15, borderRadius: const BorderRadius.all(Radius.circular(0))),
                BarChartRodData(toY: accidentData.tues.toDouble(), color: Colors.red, width: 15, borderRadius: const BorderRadius.all(Radius.circular(0))),
                BarChartRodData(toY: accidentData.blesses.toDouble(), color: Colors.green, width: 15, borderRadius: const BorderRadius.all(Radius.circular(0))),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.0,
                getTitlesWidget: (value, meta) {
                  return Text(accidentData.labelle);
                },
              ),
            )
            // leftTitles: SideTitles(showTitles: true),
          ,topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            )
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            )
          ),
           leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, 
              interval: 130,
               reservedSize: 40.0,
            )
          ),
          ),
        ),
      ),
    );
  }
}

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  late Future<List<AccidentData>> _futureAccidentData;

  @override
  void initState() {
    super.initState();
    _futureAccidentData = loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Par Mois", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        children: [
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

          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<AccidentData>>(
              future: _futureAccidentData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return BarChartSample(accidentData: snapshot.data![index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<AccidentData>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/data2.json');
  final List<dynamic> jsonData = json.decode(jsonString)['item'];
  return jsonData.map((json) => AccidentData.fromJson(json)).toList();
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Third(),
//     );
//   }
// }
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