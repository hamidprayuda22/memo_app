
class Task {
  final String id;
  final String memoId;
  final String title;
  final String description;
  final String status; 
  final String time;
  final int persons;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.memoId,
    required this.title,
    required this.description,
    required this.status,
    required this.time,
    required this.persons,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? memoId,
    String? title,
    String? description,
    String? status,
    String? time,
    int? persons,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      memoId: memoId ?? this.memoId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      time: time ?? this.time,
      persons: persons ?? this.persons,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      memoId: json['memo_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Running',
      time: json['time'] ?? '',
      persons: json['persons'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memo_id': memoId,
      'title': title,
      'description': description,
      'status': status,
      'time': time,
      'persons': persons,
      'created_at': createdAt.toIso8601String(),
    };
  }
}