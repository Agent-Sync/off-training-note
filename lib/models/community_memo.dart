import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/utils/trick_helpers.dart';

class CommunityMemo {
  const CommunityMemo({
    required this.memo,
    required this.trick,
    required this.profile,
    required this.likeCount,
    required this.likedByMe,
  });

  final TechMemo memo;
  final Trick trick;
  final Profile profile;
  final int likeCount;
  final bool likedByMe;

  String displayUserName() {
    final name = profile.displayName;
    if (name != null && name.trim().isNotEmpty) {
      return name;
    }
    return '名無し';
  }

  String trickName() => trick.displayName();

  CommunityMemo copyWith({
    int? likeCount,
    bool? likedByMe,
  }) {
    return CommunityMemo(
      memo: memo,
      trick: trick,
      profile: profile,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}
