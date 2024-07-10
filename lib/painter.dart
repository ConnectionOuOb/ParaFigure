import 'dart:ui';
import 'package:flutter/material.dart';

class FigPainter extends CustomPainter {
  final int numLayer;
  final double padding;
  final double paddingParaName;
  final Map<double, List<int>> combinations;
  final Map<String, List<String>> parameters;

  FigPainter({
    required this.numLayer,
    required this.padding,
    required this.paddingParaName,
    required this.combinations,
    required this.parameters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawLine(canvas, size);
    _drawAxis(canvas, size);
    _drawBorder(canvas, size);
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

    double verticalStart = paddingParaName + padding;
    double verticalInterval = size.height - padding * 2 - paddingParaName;
    double horizontalInterval = (size.width - padding * 2) / parameters.keys.length;
    double horizontalPointer = padding + horizontalInterval / 2;

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
        // draw background of text
        textPainter.text = TextSpan(
          text: paraValue,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        );
        textPainter.layout();

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromPoints(
              Offset(horizontalPointer - textPainter.width - 15, paramNamePointer - textPainter.height / 2),
              Offset(horizontalPointer - 15, paramNamePointer + textPainter.height / 2),
            ),
            const Radius.circular(4.0),
          ),
          Paint()..color = Colors.white,
        );

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

  _drawLine(canvas, size) {
    int index = 0;
    double cutoffLayer = numLayer > 0 ? 1 / numLayer : 0;
    double cutoffIndex = combinations.length / numLayer;
    double verticalStart = paddingParaName + padding;
    double verticalInterval = size.height - padding * 2 - paddingParaName;
    double horizontalInterval = (size.width - padding * 2) / parameters.keys.length;

    for (var combination in combinations.entries) {
      double horizontalPointer = padding + horizontalInterval / 2;
      List<Offset> points = [];

      for (var paraIndex = 0; paraIndex < parameters.keys.length; paraIndex++) {
        int numArgs = (parameters[parameters.keys.elementAt(paraIndex)] ?? []).length;

        points.add(
          Offset(
            horizontalPointer,
            verticalStart + verticalInterval / (numArgs - 1) * combination.value[paraIndex],
          ),
        );

        horizontalPointer += horizontalInterval;
      }

      canvas.drawPoints(
        PointMode.polygon,
        points,
        Paint()
          ..color = Colors.blue.withOpacity(cutoffLayer == 0 ? index / combinations.length : ((index / cutoffIndex).floor() + 1) * cutoffLayer)
          ..blendMode = BlendMode.src
          ..style = PaintingStyle.fill
          ..strokeWidth = 4,
      );

      index++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
