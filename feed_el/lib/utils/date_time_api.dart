extension NullChangeForDash on DateTime {
  String toDateString() {
    return this.toIso8601String().split('T').first;
  }
}
