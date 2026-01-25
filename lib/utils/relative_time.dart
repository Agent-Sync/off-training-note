String formatRelativeTime(DateTime target, {DateTime? now}) {
  final current = now ?? DateTime.now();
  var diffSeconds = current.difference(target).inSeconds;

  // Guard against future timestamps causing negative values like "-123秒前".
  if (diffSeconds < 0) {
    diffSeconds = 0;
  }

  const minute = 60;
  const hour = 60 * minute;
  const day = 24 * hour;
  const week = 7 * day;
  const month = 30 * day;
  const year = 365 * day;

  if (diffSeconds < minute) {
    return '$diffSeconds秒前';
  }
  if (diffSeconds < hour) {
    final minutes = diffSeconds ~/ minute;
    return '$minutes分前';
  }
  if (diffSeconds < day) {
    final hours = diffSeconds ~/ hour;
    return '$hours時間前';
  }
  if (diffSeconds < week) {
    final days = diffSeconds ~/ day;
    return '$days日前';
  }
  if (diffSeconds < month) {
    final weeks = diffSeconds ~/ week;
    return '$weeks週間前';
  }
  if (diffSeconds < year) {
    final months = diffSeconds ~/ month;
    return '$monthsか月前';
  }

  final years = diffSeconds ~/ year;
  return '$years年前';
}
