import 'data.dart';
import 'text2fig.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FigHPO());
}

class FigHPO extends StatelessWidget {
  FigHPO({super.key});

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
