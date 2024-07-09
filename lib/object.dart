class Parameter {
  String name;
  List<String> values;

  Parameter({
    required this.name,
    required this.values,
  });
}

class Data {
  int iteration;
  int wordLength;
  String matrix;
  int gapOpen;
  int gapExtend;
  double precision;
  double time;

  Data({
    required this.iteration,
    required this.wordLength,
    required this.matrix,
    required this.gapOpen,
    required this.gapExtend,
    required this.precision,
    required this.time,
  });
}
