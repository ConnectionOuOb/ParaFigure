import 'painter.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Text2Figure extends StatefulWidget {
  final int sortColIndex;
  final int numParameter;
  final int numLayer;
  final double width;
  final double height;
  final double padding;
  final double paddingParaName;
  final String resource;
  final String figureName;

  const Text2Figure({
    super.key,
    required this.width,
    required this.height,
    required this.sortColIndex,
    required this.numParameter,
    required this.resource,
    this.numLayer = 0,
    this.padding = 30,
    this.paddingParaName = 50,
    this.figureName = 'fig',
  });

  @override
  State<Text2Figure> createState() => _Text2FigureState();
}

class _Text2FigureState extends State<Text2Figure> {
  final GlobalKey _key = GlobalKey();
  Map<double, List<int>> combinations = {};
  Map<String, List<String>> parameters = {};

  @override
  void initState() {
    List<String> lines = widget.resource.split('\n');

    for (var colName in lines[0].split('\t').sublist(0, widget.numParameter)) {
      parameters[colName] = [];
    }

    for (var line in lines.sublist(1)) {
      var cols = line.split('\t');

      if (cols.length < parameters.keys.length) {
        continue;
      }

      int colIndex = 0;
      for (var colName in parameters.keys) {
        if (colIndex >= widget.numParameter) {
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

      if (cols.length < widget.sortColIndex) {
        continue;
      }

      List<int> classes = [];
      for (var i = 0; i < widget.numParameter; i++) {
        classes.add(parameters[parameters.keys.elementAt(i)]!.indexOf(cols[i]));
      }

      combinations[double.parse(cols[widget.sortColIndex - 1])] = classes;
    }

    combinations = Map.fromEntries(combinations.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RepaintBoundary(
          key: _key,
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            painter: FigPainter(
              numLayer: widget.numLayer,
              padding: widget.padding,
              paddingParaName: widget.paddingParaName,
              combinations: combinations,
              parameters: parameters,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget2png();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> widget2png() async {
    try {
      RenderRepaintBoundary renderer = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await renderer.toImage(pixelRatio: 5);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List png = byteData!.buffer.asUint8List();
      final blob = html.Blob([png]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", "${widget.figureName}.png")
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint('Error in widget2png: $e');
    }
  }
}
