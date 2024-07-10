import 'package:flutter/material.dart';

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
