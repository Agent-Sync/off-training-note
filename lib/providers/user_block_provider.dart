import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/repositories/user_block_repository.dart';

final userBlockRepositoryProvider = Provider<UserBlockRepository>(
  (ref) => const UserBlockRepository(),
);
