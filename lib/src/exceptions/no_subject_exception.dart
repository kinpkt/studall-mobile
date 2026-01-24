class NoSubjectException implements Exception {
  final String message;

  const NoSubjectException([this.message = "An unknown error occurred."]);

  @override
  String toString() => 'NoSubjectException: $message';
}