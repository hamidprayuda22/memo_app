import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../models/memos.dart';  
import '../repositories/memo_repository.dart';

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository();
});

class MemoNotifier extends Notifier<AsyncValue<List<Memo>>> {
  final MemoRepository _repository;

  MemoNotifier(this._repository) {
    loadMemos();
  }

  @override
  AsyncValue<List<Memo>> build() {
    return const AsyncValue.loading();  // ← WAJIB override untuk Notifier
  }

  /// READ: Load memos dari Supabase
  Future<void> loadMemos() async {
    try {
      state = const AsyncValue.loading();
      final memos = await _repository.getMemos();
      state = AsyncValue.data(memos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createMemo(String title, String status, int colorValue) async {
    try {
      final previous = state.value ?? [];
      final newMemo = await _repository.createMemo(
        title: title,
        status: status,
        colorValue: colorValue,
      );
      state = AsyncValue.data([...previous, newMemo]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTaskToMemo(String memoId) async {
    try {
      final current = state.value ?? [];
      await _repository.increaseTask(memoId);
      final updated = current.map((m) {
        if (m.id == memoId) return m.copyWith(tasks: m.tasks + 1);
        return m;
      }).toList();
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMemo(String memoId) async {
    try {
      await _repository.deleteMemo(memoId);
      final current = state.value ?? [];
      state = AsyncValue.data(
        current.where((m) => m.id != memoId).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final memoNotifierProvider = NotifierProvider<MemoNotifier, AsyncValue<List<Memo>>>(
  () => MemoNotifier(
    MemoRepository(),
  ),
);
