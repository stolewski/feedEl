extension GetDate on String {
  String subDate() {
    return this.split('T').first;
  }
}
