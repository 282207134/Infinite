import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/local_repository.dart';

enum FeedMode { fresh, activity, recommended }

extension FeedModeLabel on FeedMode {
  String get label => switch (this) {
    FeedMode.fresh => 'New',
    FeedMode.activity => 'Activity',
    FeedMode.recommended => 'Recommended',
  };
}

class AppController extends ChangeNotifier {
  AppController(this.repository) {
    final data = repository.read();
    liked.addAll(List<String>.from(data['liked'] ?? []));
    saved.addAll(List<String>.from(data['saved'] ?? []));
    following.addAll(List<String>.from(data['following'] ?? []));
    for (final entry
        in (data['comments'] as Map<String, dynamic>? ?? {}).entries) {
      comments[entry.key] = List<String>.from(entry.value as List);
    }
    messages.addAll(List<String>.from(data['messages'] ?? []));
  }
  final LocalRepository repository;
  final Set<String> liked = {}, saved = {}, following = {};
  final Map<String, List<String>> comments = {};
  final List<String> messages = [];
  FeedMode feedMode = FeedMode.fresh;
  bool grid = true;
  int tab = 0;
  String creatorQuery = '';

  void selectTab(int value) {
    tab = value;
    notifyListeners();
  }

  void selectFeed(FeedMode mode) {
    feedMode = mode;
    tab = 0;
    notifyListeners();
  }

  void setGrid(bool value) {
    grid = value;
    notifyListeners();
  }

  void toggleLike(String id) => _toggle(liked, id);
  void toggleSave(String id) => _toggle(saved, id);
  void toggleFollow(String id) => _toggle(following, id);
  void _toggle(Set<String> values, String id) {
    values.contains(id) ? values.remove(id) : values.add(id);
    _changed();
  }

  void addComment(String artworkId, String text) {
    if (text.trim().isEmpty) return;
    (comments[artworkId] ??= []).add(text.trim());
    _changed();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(text.trim());
    _changed();
  }

  void _changed() {
    notifyListeners();
    unawaited(
      repository.write({
        'liked': liked.toList(),
        'saved': saved.toList(),
        'following': following.toList(),
        'comments': comments,
        'messages': messages,
      }),
    );
  }
}
