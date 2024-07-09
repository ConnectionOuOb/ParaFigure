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
      parameter.values.sort();
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double padding = 50;
    double interval = (size.width - padding) / parameters.length;

    for (int i = 0; i < parameters.length; i++) {
      canvas.drawLine(
        Offset(padding + interval * i, padding),
        Offset(padding + interval * i, size.height - padding),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
