import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/models.dart';

String studentPreferenceKeyForUid(String base, String? uid) =>
    uid == null ? '${base}_guest' : '${base}_user_$uid';

String studentPreferenceKey(String base) =>
    studentPreferenceKeyForUid(base, FirebaseAuth.instance.currentUser?.uid);

final schoolLevelProvider =
    StateNotifierProvider<SchoolLevelNotifier, SchoolLevel>(
  (ref) => SchoolLevelNotifier(),
);

class SchoolLevelNotifier extends StateNotifier<SchoolLevel> {
  SchoolLevelNotifier() : super(SchoolLevel.sixieme) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      state = SchoolLevel.sixieme;
      _loadForUid(user?.uid);
    });
    _loadForUid(FirebaseAuth.instance.currentUser?.uid);
  }

  late final StreamSubscription<User?> _authSubscription;
  int _loadVersion = 0;

  Future<void> _loadForUid(String? uid) async {
    final version = ++_loadVersion;
    final prefs = await SharedPreferences.getInstance();
    if (version != _loadVersion ||
        FirebaseAuth.instance.currentUser?.uid != uid) return;
    final saved = prefs.getString(studentPreferenceKeyForUid(
      'student_school_level',
      uid,
    ));
    final matches = SchoolLevel.values.where((item) => item.name == saved);
    state = matches.isNotEmpty ? matches.first : SchoolLevel.sixieme;
  }

  Future<void> setLevel(SchoolLevel level) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    state = level;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setString(
      studentPreferenceKeyForUid('student_school_level', uid),
      level.name,
    );
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    super.dispose();
  }
}

final schoolTrackProvider =
    StateNotifierProvider<SchoolTrackNotifier, SchoolTrack>(
  (ref) => SchoolTrackNotifier(),
);

class SchoolTrackNotifier extends StateNotifier<SchoolTrack> {
  SchoolTrackNotifier() : super(SchoolTrack.generalLiterary) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      state = SchoolTrack.generalLiterary;
      _loadForUid(user?.uid);
    });
    _loadForUid(FirebaseAuth.instance.currentUser?.uid);
  }

  late final StreamSubscription<User?> _authSubscription;
  int _loadVersion = 0;

  Future<void> _loadForUid(String? uid) async {
    final version = ++_loadVersion;
    final prefs = await SharedPreferences.getInstance();
    if (version != _loadVersion ||
        FirebaseAuth.instance.currentUser?.uid != uid) return;
    final saved = prefs.getString(studentPreferenceKeyForUid(
      'student_school_track',
      uid,
    ));
    final matches = SchoolTrack.values.where((item) => item.name == saved);
    state = matches.isNotEmpty
        ? matches.first
        : SchoolTrack.generalLiterary;
  }

  Future<void> setTrack(SchoolTrack value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    state = value;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setString(
      studentPreferenceKeyForUid('student_school_track', uid),
      value.name,
    );
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    super.dispose();
  }
}

final schoolSeriesProvider =
    StateNotifierProvider<SchoolSeriesNotifier, String>(
  (ref) => SchoolSeriesNotifier(),
);

class SchoolSeriesNotifier extends StateNotifier<String> {
  SchoolSeriesNotifier() : super('A4') {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      state = 'A4';
      _loadForUid(user?.uid);
    });
    _loadForUid(FirebaseAuth.instance.currentUser?.uid);
  }

  late final StreamSubscription<User?> _authSubscription;
  int _loadVersion = 0;

  Future<void> _loadForUid(String? uid) async {
    final version = ++_loadVersion;
    final prefs = await SharedPreferences.getInstance();
    if (version != _loadVersion ||
        FirebaseAuth.instance.currentUser?.uid != uid) return;
    state = prefs.getString(studentPreferenceKeyForUid(
          'student_school_series',
          uid,
        )) ??
        'A4';
  }

  Future<void> setSeries(String value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    state = value;
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser?.uid != uid) return;
    await prefs.setString(
      studentPreferenceKeyForUid('student_school_series', uid),
      value,
    );
  }

  @override
  void dispose() {
    unawaited(_authSubscription.cancel());
    super.dispose();
  }
}

List<String> seriesForTrack(SchoolTrack track) => switch (track) {
      SchoolTrack.generalLiterary => ['A4'],
      SchoolTrack.scientific => ['C', 'D'],
      SchoolTrack.technicalTertiary => technicalTertiarySeries,
      SchoolTrack.technicalIndustrial => technicalIndustrialSeries,
    };
