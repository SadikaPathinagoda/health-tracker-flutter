// health_record.dart
class HealthRecord {
  final int? id;
  final String date;     // 'YYYY-MM-DD'
  final int steps;
  final int calories;
  final int water;

  HealthRecord({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'steps': steps,
      'calories': calories,
      'water': water,
    };
  }
}
