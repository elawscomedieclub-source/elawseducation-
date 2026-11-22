import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

/// Measures authenticated app usage only. No page content or personal data is sent.
class UsageTrackingService with WidgetsBindingObserver {
  UsageTrackingService._();

  static final UsageTrackingService instance = UsageTrackingService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _api =
      'https://proftogo-api.proftogo-metrics.workers.dev';
  final Uuid _uuid = const Uuid();

  StreamSubscription<User?>? _authSubscription;
  Timer? _heartbeatTimer;
  String? _sessionId;
  String? _activeUid;
  int _authGeneration = 0;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _authSubscription ??= _auth.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    _authGeneration++;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _sessionId = null;
    _activeUid = user?.uid;
    if (user == null) return;

    _sessionId = _uuid.v4().replaceAll('-', '');
    _sendHeartbeat();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _sendHeartbeat(),
    );
  }

  Future<void> _sendHeartbeat() async {
    final uid = _activeUid;
    final sessionId = _sessionId;
    final generation = _authGeneration;
    if (uid == null || sessionId == null) return;
    // Do not block learning if analytics is unavailable or offline.
    try {
      final user = _auth.currentUser;
      if (user?.uid != uid) return;
      final token = await user?.getIdToken();
      // A login/logout may occur while Firebase is refreshing the token.
      // Never send an old session with a token belonging to a new account.
      if (token == null ||
          generation != _authGeneration ||
          _activeUid != uid ||
          _sessionId != sessionId ||
          _auth.currentUser?.uid != uid) return;
      await http.post(
        Uri.parse('$_api/api/heartbeat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'sessionId': sessionId}),
      );
    } catch (_) {
      // The next heartbeat retries automatically.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sendHeartbeat();
    }
  }

  void dispose() {
    _authGeneration++;
    _activeUid = null;
    _sessionId = null;
    WidgetsBinding.instance.removeObserver(this);
    _heartbeatTimer?.cancel();
    _authSubscription?.cancel();
  }
}
