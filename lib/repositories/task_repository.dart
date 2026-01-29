import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Task>> getTasksByMemoId(String memoId) async {
    final data = await _supabase
        .from('tasks')
        .select()
        .eq('memo_id', memoId)
        .order('created_at', ascending: false);
    
    return (data as List<dynamic>)
        .map((row) => Task.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<Task> createTask({
    required String memoId,
    required String title,
    required String description,
    required String status,
    required String time,
    required int persons,
  }) async {
    final inserted = await _supabase.from('tasks').insert({
      'memo_id': memoId,
      'title': title,
      'description': description,
      'status': status,
      'time': time,
      'persons': persons,
    }).select().single();

    return Task.fromJson(inserted);
  }

  Future<Task> updateTask({
    required String taskId,
    required String title,
    required String description,
    required String status,
    required String time,
    required int persons,
  }) async {
    final updated = await _supabase
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'status': status,
          'time': time,
          'persons': persons,
        })
        .eq('id', taskId)
        .select()
        .single();

    return Task.fromJson(updated);
  }

  Future<void> deleteTask(String taskId) async {
    await _supabase.from('tasks').delete().eq('id', taskId);
  }
}