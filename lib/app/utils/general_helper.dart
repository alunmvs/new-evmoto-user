String formatDoubleToString(double value) {
  double rounded = double.parse(value.toStringAsFixed(2));

  if (rounded % 1 == 0) {
    return rounded.toInt().toString();
  }

  return rounded.toString();
}
