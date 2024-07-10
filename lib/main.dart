import 'data.dart';
import 'text2fig.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FigHPO());
}

class FigHPO extends StatelessWidget {
  const FigHPO({super.key});

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
        width: 1200,
        height: 800,
        figureName: "NCBI BLAST blastp Speed",
        numParameter: 4,
        sortColIndex: 6,
        resource: data,
      ),
    );
  }
}
