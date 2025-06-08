class CoreErrors implements Exception {
  final String message;

  CoreErrors(this.message);

  @override
  String toString() => 'CoreErrors: $message';
}
