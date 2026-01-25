import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/repositories/tricks_repository.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final tricksProvider = NotifierProvider<TricksNotifier, List<Trick>>(
  TricksNotifier.new,
);

final tricksRepositoryProvider = Provider<TricksRepository>((ref) {
  return const TricksRepository();
});

final userTricksProvider =
    FutureProvider.family<List<Trick>, String>((ref, userId) async {
  final repo = ref.read(tricksRepositoryProvider);
  final viewerUserId = Supabase.instance.client.auth.currentUser?.id;
  return repo.fetchTricks(userId: userId, viewerUserId: viewerUserId);
});

class TricksNotifier extends Notifier<List<Trick>> {
  @override
  List<Trick> build() {
    _loadTricks();
    return const [];
  }

  Future<void> _loadTricks() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = const [];
      return;
    }
    final repo = ref.read(tricksRepositoryProvider);
    state = await repo.fetchTricks(userId: userId);
  }

  Future<void> addTrick(Trick trick) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return;
    }
    final repo = ref.read(tricksRepositoryProvider);
    await repo.addTrick(userId: userId, trick: trick);
    await _loadTricks();
  }

  Future<void> updateTrickStatus(String trickId, bool isPublic) async {
    final repo = ref.read(tricksRepositoryProvider);
    await repo.updateTrickStatus(trickId: trickId, isPublic: isPublic);

    state = [
      for (final trick in state)
        if (trick.id == trickId)
          trick.map(
            air: (air) =>
                air.copyWith(meta: air.meta.copyWith(isPublic: isPublic)),
            jib: (jib) =>
                jib.copyWith(meta: jib.meta.copyWith(isPublic: isPublic)),
          )
        else
          trick
    ];
  }

  Future<void> addMemo(
    String trickId,
    String focus,
    String outcome, {
    MemoCondition? condition,
    MemoSize? size,
  }) async {
    final target = state.cast<Trick?>().firstWhere(
          (trick) => trick?.id == trickId,
          orElse: () => null,
        );
    if (target == null) {
      return;
    }
    final repo = ref.read(tricksRepositoryProvider);
    await repo.addMemo(
      trick: target,
      focus: focus,
      outcome: outcome,
      condition: condition,
      size: size,
    );
    await _loadTricks();
  }

  Future<void> updateMemo(String trickId, TechMemo updatedMemo) async {
    final repo = ref.read(tricksRepositoryProvider);
    await repo.updateMemo(memo: updatedMemo);
    await _loadTricks();
  }

  Future<void> deleteMemo(String trickId, String memoId) async {
    final repo = ref.read(tricksRepositoryProvider);
    await repo.deleteMemo(memoId: memoId);
    await _loadTricks();
  }

  Future<void> refresh() async {
    await _loadTricks();
  }
}
