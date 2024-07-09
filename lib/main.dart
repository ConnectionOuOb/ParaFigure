import 'data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HPO());
}

class HPO extends StatelessWidget {
  const HPO({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HPO Figure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Text2Figure(
        setIndex: 5,
        endIndex: 5,
        resource: psiblast,
      ),
    );
  }
}

class Text2Figure extends StatefulWidget {
  final int setIndex;
  final int endIndex;
  final String resource;

  const Text2Figure({
    super.key,
    required this.setIndex,
    required this.endIndex,
    required this.resource,
  });

  @override
  State<Text2Figure> createState() => _Text2FigureState();
}

class _Text2FigureState extends State<Text2Figure> {
  Map<double, List<int>> combinations = {};
  Map<String, List<String>> parameters = {};

  @override
  void initState() {
    List<String> lines = psiblast.split('\n');

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
        value.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      } catch (e) {
        value.sort((a, b) => a.compareTo(b));
      }
    });

    for (var line in lines.sublist(1, 5)) {
      var cols = line.split('\t');
      if (cols.length < widget.setIndex - 1) {
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
          painter: FigPainter(),
        ),
      ),
    );
  }
}

class FigPainter extends CustomPainter {
  //final List<Data> instances;
  //final List<Parameter> parameters;

  FigPainter(/*this.instances, this.parameters*/);

  @override
  void paint(Canvas canvas, Size size) {
    /*(canvas, size);
    _drawAxis(canvas, size);
    _drawLine(canvas, size);*/
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

/*
  _drawAxis(canvas, size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double padding = 50;
    double paddingText = 20;
    double interval = (size.width - padding * 2) / parameters.length;
    double pointer = padding + interval / 2;
    double lineInterval = size.height - padding * 2 - paddingText;

    for (var p in parameters) {
      canvas.drawLine(
        Offset(pointer, padding + paddingText),
        Offset(pointer, size.height - padding),
        paint,
      );

      textPainter.text = TextSpan(text: p.name, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(canvas, Offset(pointer - textPainter.width / 2, padding - textPainter.height - 5));

      double valInterval = lineInterval / (p.values.length - 1);
      double valPointer = padding + paddingText;

      for (var v in p.values) {
        textPainter.text = TextSpan(text: v, style: const TextStyle(color: Colors.black, fontSize: 20));
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(pointer - textPainter.width / 2 - (p.name == "Matrix" ? 65 : 25), valPointer - textPainter.height / 2),
        );

        canvas.drawCircle(Offset(pointer, valPointer), 5, paint);

        valPointer += valInterval;
      }

      pointer += interval;
    }
  }*/
/*
  _drawLine(canvas, size) {
    var paint = Paint()..color = Colors.blue;

    for (var inst in instances) {}
  }
*/
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
