import 'package:flutter/material.dart';

class Text2Figure extends StatefulWidget {
  final int setIndex;
  final int endIndex;
  final double padding;
  final double paddingParaName;
  final String resource;

  const Text2Figure({
    super.key,
    required this.setIndex,
    required this.endIndex,
    required this.resource,
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: const Size(1200, 800),
          painter: FigPainter(
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

class FigPainter extends CustomPainter {
  final double padding;
  final double paddingParaName;
  final Map<double, List<int>> combinations;
  final Map<String, List<String>> parameters;

  FigPainter({
    required this.padding,
    required this.paddingParaName,
    required this.combinations,
    required this.parameters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBorder(canvas, size);
    _drawAxis(canvas, size);
    /*_drawLine(canvas, size);*/
  }

  _drawBorder(canvas, size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      paint,
    );
  }

  _drawAxis(canvas, size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double horizontalInterval = (size.width - padding * 2) / parameters.keys.length;
    double horizontalPointer = padding + horizontalInterval / 2;
    double verticalStart = paddingParaName + padding;
    double verticalInterval = size.height - padding * 2 - paddingParaName;

    for (var p in parameters.keys) {
      canvas.drawLine(
        Offset(horizontalPointer, verticalStart),
        Offset(horizontalPointer, size.height - padding),
        paint,
      );

      textPainter.text = TextSpan(
        text: p,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          horizontalPointer - textPainter.width / 2,
          padding,
        ),
      );

      List<String> paramNames = parameters[p] ?? [];
      double paramNameInterval = verticalInterval / (paramNames.length - 1);
      double paramNamePointer = verticalStart;

      for (var paraValue in paramNames) {
        textPainter.text = TextSpan(
          text: paraValue,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            horizontalPointer - textPainter.width - 15,
            paramNamePointer - textPainter.height / 2,
          ),
        );

        canvas.drawCircle(
          Offset(horizontalPointer, paramNamePointer),
          5,
          paint,
        );

        paramNamePointer += paramNameInterval;
      }

      horizontalPointer += horizontalInterval;
    }
  }

/*
  _drawLine(canvas, size) {
    var paint = Paint()..color = Colors.blue;

    for (var inst in instances) {}
  }
*/
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
