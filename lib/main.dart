import 'data.dart';
import 'object.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Data> instances = [];
  List<Parameter> parameters = [
    Parameter(name: 'Iteration', values: []),
    Parameter(name: 'Word Length', values: []),
    Parameter(name: 'Matrix', values: []),
    Parameter(name: 'Gap Open', values: []),
    Parameter(name: 'Gap Extend', values: []),
  ];

  @override
  void initState() {
    for (var line in psiblast.split('\n')) {
      var parts = line.split('\t');
      int iteration = int.parse(parts[0]);
      int wordLength = int.parse(parts[1]);
      String matrix = parts[2];
      int gapOpen = int.parse(parts[3]);
      int gapExtend = int.parse(parts[4]);

      instances.add(
        Data(
          iteration: iteration,
          wordLength: wordLength,
          matrix: matrix,
          gapOpen: gapOpen,
          gapExtend: gapExtend,
          precision: double.parse(parts[5]),
          time: double.parse(parts[6]),
        ),
      );

      if (!parameters[0].values.contains(iteration.toString())) {
        parameters[0].values.add(iteration.toString());
      }

      if (!parameters[1].values.contains(wordLength.toString())) {
        parameters[1].values.add(wordLength.toString());
      }

      if (!parameters[2].values.contains(matrix)) {
        parameters[2].values.add(matrix);
      }

      if (!parameters[3].values.contains(gapOpen.toString())) {
        parameters[3].values.add(gapOpen.toString());
      }

      if (!parameters[4].values.contains(gapExtend.toString())) {
        parameters[4].values.add(gapExtend.toString());
      }
    }

    for (var parameter in parameters) {
      if (parameter.name == 'Matrix') {
        parameter.values.sort();
      } else {
        parameter.values.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      }
      print('${parameter.name}: ${parameter.values}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: const Size(1200, 800),
          painter: FigPainter(instances, parameters),
        ),
      ),
    );
  }
}

class FigPainter extends CustomPainter {
  final List<Data> instances;
  final List<Parameter> parameters;

  FigPainter(this.instances, this.parameters);

  @override
  void paint(Canvas canvas, Size size) {
    _drawBorder(canvas, size);
    _drawAxis(canvas, size);
    _drawCurve(canvas, size);
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
  }

  _drawCurve(canvas, size) {
    var paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double padding = 50;
    double interval = (size.width - padding * 2) / parameters.length;
    double lineInterval = size.height - padding * 2 - 20;

    for (var i = 0; i < instances.length - 1; i++) {
      var p1 = instances[i];
      var p2 = instances[i + 1];

      double x1 = padding + interval * parameters.indexOf(parameters.firstWhere((p) => p.name == 'Iteration'));
      double x2 = padding + interval * parameters.indexOf(parameters.firstWhere((p) => p.name == 'Iteration', i + 1));

      double y1 = padding + 20 + lineInterval * parameters.firstWhere((p) => p.name == 'Word Length').values.indexOf(p1.wordLength.toString());
      double y2 = padding + 20 + lineInterval * parameters.firstWhere((p) => p.name == 'Word Length').values.indexOf(p2.wordLength.toString());

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
