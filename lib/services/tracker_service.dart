import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/wish.dart';

class TrackerService {
  Timer? _timer;
  Wish? _wish;
  final VoidCallback onUpdate;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _selectedTimeZone = "America/New_York"; // Change initial value
  DateTime _currentTime = DateTime.now().toUtc();

  TrackerService({required this.onUpdate});

  Future<void> startTracking(String description, double years) async {
    _wish = Wish(
      description: description,
      endTime: DateTime.now().add(Duration(days: (years * 365).round())),
    );
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      if (_wish!.isCompleted) {
        _timer?.cancel();
        return;
      }
      _currentTime = DateTime.now().toUtc();
      await _playTickSound();
      onUpdate();
    });
  }

  void setTimeZone(String timeZone) {
    _selectedTimeZone = timeZone;
    onUpdate();
  }

  Future<void> _playTickSound() async {
    await _audioPlayer.play(AssetSource('sounds/tick.mp3'), volume: 0.5);
  }

  Duration getRemainingTime() => _wish?.remainingTime ?? Duration.zero;
  String getWishDescription() => _wish?.description ?? "No wish set";
  DateTime getCurrentTime() {
    Map<String, Duration> offsets = {
      "America/New_York": Duration(hours: -4),
      "Europe/London": Duration(hours: 0),
      "Asia/Kolkata": Duration(hours: 5, minutes: 30),
      "Asia/Tokyo": Duration(hours: 9),
      "Australia/Sydney": Duration(hours: 10),
      "Asia/Dhaka": Duration(hours: 6),
      "America/Toronto": Duration(hours: -4),
      "Europe/Helsinki": Duration(hours: 2),
      "America/Sao_Paulo": Duration(hours: -3),
      "Africa/Johannesburg": Duration(hours: 2),
      "Europe/Moscow": Duration(hours: 3),
      "Asia/Shanghai": Duration(hours: 8),
      "UTC": Duration.zero, // Already included
    };
    return _currentTime.add(offsets[_selectedTimeZone] ?? Duration.zero);
  }

  String getTimeZone() => _selectedTimeZone;

  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
  }
}
