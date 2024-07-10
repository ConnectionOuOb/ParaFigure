import 'painter.dart';
import 'package:flutter/material.dart';

class Text2Figure extends StatefulWidget {
  final int setIndex;
  final int endIndex;
  final int numLayer;
  final double padding;
  final double paddingParaName;
  final String resource;

  const Text2Figure({
    super.key,
    required this.setIndex,
    required this.endIndex,
    required this.resource,
    this.numLayer = 0,
    this.padding = 30,
    this.paddingParaName = 50,
  });

  @override
  State<Text2Figure> createState() => _Text2FigureState();
}

class _Text2FigureState extends State<Text2Figure> {
  Map<double, List<int>> combinations = {};
  Map<String, List<String>> parameters = {};

  @override
  void initState() {
    List<String> lines = widget.resource.split('\n');

    for (var colName in lines[0].split('\t').sublist(0, widget.endIndex)) {
      parameters[colName] = [];
    }

    for (var line in lines.sublist(1)) {
      var cols = line.split('\t');

      if (cols.length < parameters.keys.length) {
        continue;
      }

      int colIndex = 0;
      for (var colName in parameters.keys) {
        if (colIndex >= widget.endIndex) {
          break;
        }

        if (!parameters[colName]!.contains(cols[colIndex])) {
          parameters[colName]!.add(cols[colIndex]);
        }

        colIndex++;
      }
    }

    parameters.forEach((key, value) {
      try {
        value.sort((a, b) => double.parse(a).compareTo(double.parse(b)));
      } catch (e) {
        value.sort((a, b) => a.compareTo(b));
      }
    });

    for (var line in lines.sublist(1)) {
      var cols = line.split('\t');
      if (cols.length < widget.setIndex + 1) {
        continue;
      }

      List<int> classes = [];
      for (var i = 0; i < widget.setIndex; i++) {
        classes.add(parameters[parameters.keys.elementAt(i)]!.indexOf(cols[i]));
      }
      combinations[double.parse(cols[widget.setIndex])] = classes;
    }

    combinations = Map.fromEntries(combinations.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: const Size(1200, 800),
          painter: FigPainter(
            numLayer: widget.numLayer,
            padding: widget.padding,
            paddingParaName: widget.paddingParaName,
            combinations: combinations,
            parameters: parameters,
          ),
        ),
      ),
    );
  }
}
