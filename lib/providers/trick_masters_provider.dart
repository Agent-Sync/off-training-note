import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/core/trick_masters.dart';
import 'package:off_training_note/repositories/trick_masters_repository.dart';

final trickMastersRepositoryProvider = Provider<TrickMastersRepository>((ref) {
  return const TrickMastersRepository();
});

final trickMastersProvider = FutureProvider<TrickMasterData>((ref) async {
  final repo = ref.read(trickMastersRepositoryProvider);
  return repo.fetchMasters();
});
