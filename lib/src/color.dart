class Color {
  final int r;
  final int g;
  final int b;

  const Color(this.r, this.g, this.b);

  @override
  String toString() {
    return "#" +
        (r & 0xff).toRadixString(16).padLeft(2, "0") +
        (g & 0xff).toRadixString(16).padLeft(2, "0") +
        (b & 0xff).toRadixString(16).padLeft(2, "0");
  }
}
