Iterable<int> range(int start, [int stop, int step = 1]) sync* {
  if (step == 0) {
    throw ArgumentError("step must not be 0");
  }
  if (stop == null) {
    stop = start;
    start = 0;
  }

  if (step > 0) {
    for (var i = start; i < stop; i += step) {
      yield i;
    }
  } else {
    for (var i = start; i > stop; i += step) {
      yield i;
    }
  }
}
