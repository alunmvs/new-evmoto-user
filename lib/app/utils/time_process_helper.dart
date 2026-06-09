Future<T> measureTime<T>(String label, Future<T> Function() function) async {
  final stopwatch = Stopwatch()..start();
  final result = await function();
  stopwatch.stop();
  return result;
}
