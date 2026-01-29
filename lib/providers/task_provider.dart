import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskNotifier extends Notifier<AsyncValue<List<Task>>> {
  late final SupabaseClient _client;
  String? _currentMemoId;

  @override
  AsyncValue<List<Task>> build() {
    _client = Supabase.instance.client;
    return const AsyncValue.loading();
  }

  Future<void> setMemoId(String memoId) async {
    _currentMemoId = memoId;
    await loadTasks();
  }

  Future<void> loadTasks() async {
    if (_currentMemoId == null) return;
    try {
      final response = await _client
          .from('tasks')
          .select()
          .eq('memo_id', _currentMemoId!)
          .order('created_at', ascending: false);
      
      final tasks = (response as List).map((e) => Task.fromJson(e)).toList();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String status,
    required String time,
    required int persons,
  }) async {
    if (_currentMemoId == null) return;
    try {
      final response = await _client
          .from('tasks')
          .insert({
            'memo_id': _currentMemoId,
            'title': title,
            'description': description,
            'status': status,
            'time': time,
            'persons': persons,
          })
          .select()
          .single();
      
      final newTask = Task.fromJson(response);
      
      state = state.whenData((tasks) => [newTask, ...tasks]);
      
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _client.from('tasks').delete().eq('id', taskId);
      
      state = state.whenData((tasks) => 
        tasks.where((t) => t.id != taskId).toList()
      );
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}

final taskNotifierProvider = NotifierProvider<TaskNotifier, AsyncValue<List<Task>>>(
  TaskNotifier.new,
);
