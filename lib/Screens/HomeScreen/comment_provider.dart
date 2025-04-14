import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  // Map to track the visibility of comments for each video
  final Map<String, bool> _commentVisibility = {};

  // Check if comments are visible for a given videoId
  bool isCommentVisible(String videoId) {
    return _commentVisibility[videoId] ?? false;
  }

  // Toggle the visibility of comments for a given videoId
  void toggleCommentVisibility(String videoId) {
    // Toggle the visibility: if it exists, flip it; otherwise, set it to true
    _commentVisibility[videoId] = !(_commentVisibility[videoId] ?? false);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Optional: Reset all comment visibility states
  void resetCommentVisibility() {
    _commentVisibility.clear();
    notifyListeners(); // Notify listeners to update the UI
  }
}
