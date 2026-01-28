import 'package:state_notifier/state_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/memos.dart';

final supabase = Supabase.instance.client;

class MemoNotifier extends StateNotifier<List<Memo>> {
  MemoNotifier() : super([]) {
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final response = await supabase.from('memos').select().order('created_at', ascending: false);
    state = response.map((json) => Memo.fromJson(json)).toList();
  }

  Future<void> addMemo(Memo memo) async {
    await supabase.from('memos').insert(memo.toJson()).select();
    state = [memo, ...state];
  }

  Future<void> removeMemo(String id) async {
    await supabase.from('memos').delete().eq('id', id);
    state = state.where((memo) => memo.id != id).toList();
  }

  Future<void> updateMemo(Memo updated) async {
    await supabase.from('memos').update(updated.toJson()).eq('id', updated.id);
    final index = state.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      state = [...state..[index] = updated];
    }
  }

  Future<void> refresh() => _loadMemos();
}
