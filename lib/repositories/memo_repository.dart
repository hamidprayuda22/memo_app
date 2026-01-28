import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/memos.dart';

class MemoRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Memo>> getMemos() async {
    final data = await _supabase
        .from('memos')
        .select()
        .order('created_at', ascending: false); 
    return (data as List<dynamic>)
        .map((row) => Memo.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<Memo> createMemo({
    required String title,
    required String status,
    required int colorValue,
  }) async {
    final inserted = await _supabase.from('memos').insert({
      'title': title,
      'status': status,
      'color': colorValue, 
      'tasks': 0,
    }).select().single();
    return Memo.fromJson(inserted);
  }

  Future<void> increaseTask(String memoId) async {
    final current = await _supabase
        .from('memos')
        .select('tasks')
        .eq('id', memoId)
        .single();
    
    final newTasks = (current['tasks'] as int) + 1;
    
    await _supabase
        .from('memos')
        .update({'tasks': newTasks})
        .eq('id', memoId);
  }

  Future<void> deleteMemo(String memoId) async {
    await _supabase.from('memos').delete().eq('id', memoId);
  }
}