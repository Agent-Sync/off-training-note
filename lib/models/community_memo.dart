import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/utils/trick_helpers.dart';

class CommunityMemo {
  const CommunityMemo({
    required this.memo,
    required this.trick,
    required this.profile,
  });

  final TechMemo memo;
  final Trick trick;
  final Profile profile;

  String displayUserName() {
    final name = profile.displayName;
    if (name != null && name.trim().isNotEmpty) {
      return name;
    }
    return 'No Name';
  }

  String trickName() => trick.displayName();

  CommunityMemo copyWith({
    TechMemo? memo,
    Trick? trick,
    Profile? profile,
  }) {
    return CommunityMemo(
      memo: memo ?? this.memo,
      trick: trick ?? this.trick,
      profile: profile ?? this.profile,
    );
  }
}
