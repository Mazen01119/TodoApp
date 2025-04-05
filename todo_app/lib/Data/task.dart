import 'package:hive/hive.dart';

part 'task.g.dart'; // Ensure you have this part directive for code generation

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  final int priority;

  @HiveField(4)
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate, // Make dueDate optional
    this.isCompleted = false, // Default value for isCompleted
  });
}