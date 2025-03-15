class Wish {
  final String description;
  final DateTime endTime;

  Wish({required this.description, required this.endTime});

  Duration get remainingTime => endTime.difference(DateTime.now());

  bool get isCompleted => remainingTime.isNegative;
}