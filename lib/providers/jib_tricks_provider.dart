import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/jib_trick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final _jibUuid = Uuid();

final jibTricksProvider = NotifierProvider<JibTricksNotifier, List<JibTrick>>(
  JibTricksNotifier.new,
);

class JibTricksNotifier extends Notifier<List<JibTrick>> {
  static const _storageKey = 'jib_tricks_data';

  @override
  List<JibTrick> build() {
    _loadJibTricks();
    return _initialJibTricks;
  }

  Future<void> _loadJibTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      state = jsonList.map((e) => JibTrick.fromJson(e)).toList();
    } else {
      _saveJibTricks();
    }
  }

  Future<void> _saveJibTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void addJibTrick(String customName) {
    final jib = JibTrick(
      id: _jibUuid.v4(),
      customName: customName,
      createdAt: DateTime.now(),
    );
    state = [jib, ...state];
    _saveJibTricks();
  }

  static final List<JibTrick> _initialJibTricks = [
    JibTrick(
      id: _jibUuid.v4(),
      customName: 'フロントボードスライド',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    JibTrick(
      id: _jibUuid.v4(),
      customName: 'スイッチテールプレス',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}
