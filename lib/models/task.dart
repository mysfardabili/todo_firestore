import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final String priority; // 'Tinggi', 'Sedang', 'Rendah'
  final DateTime? timestamp;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isDone,
    this.priority = 'Sedang',
    this.timestamp,
  });

  factory Task.fromDoc(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] as String?,
      isDone: data['isDone'] ?? false,
      priority: data['priority'] ?? 'Sedang',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'isDone': isDone,
      'priority': priority,
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
    };
  }
}
