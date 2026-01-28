import 'package:flutter/material.dart';

class Memo {
  final String id;
  final String title;
  final String status;
  final int tasks;
  final Color color;

  Memo({
    required this.id,
    required this.title,
    required this.status,
    required this.tasks,
    required this.color,
  });

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      tasks: (json['tasks'] ?? 0) as int,
      color: Color(int.parse(json['color'] as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'color': color.value.toString(),
      'tasks': tasks,
    };
  }

  Memo copyWith({
    String? id,
    String? title,
    String? status,
    int? tasks,
    Color? color,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      color: color ?? this.color,
    );
  }
}
