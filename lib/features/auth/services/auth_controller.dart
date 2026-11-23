import 'package:flutter/foundation.dart';

import '../models/member_model.dart';

/// Mock authentication controller (frontend only).
/// Keeps accounts in memory until the backend is ready.
class AuthController extends ChangeNotifier {
  AuthController._();

  static final AuthController instance = AuthController._();

  // Mock "database": email -> password
  final Map<String, String> _passwords = {
    'demo@smartclub.com': 'Demo1234',
    'expired@smartclub.com': 'Demo1234',
  };

  // Mock "database": email -> member
  final Map<String, Member> _members = {
    'demo@smartclub.com': Member(
      id: '1',
      fullName: 'Mahmoud Ali',
      email: 'demo@smartclub.com',
      phone: '+20 100 123 4567',
      membershipNumber: 'SC-10001',
      membershipType: MembershipType.gold,
      joinDate: DateTime(2025, 1, 15),
      expiryDate: DateTime(2027, 1, 15),
    ),
    'expired@smartclub.com': Member(
      id: '2',
      fullName: 'Omar Hassan',
      email: 'expired@smartclub.com',
      phone: '+20 111 765 4321',
      membershipNumber: 'SC-10002',
      membershipType: MembershipType.silver,
      joinDate: DateTime(2024, 3, 1),
      expiryDate: DateTime(2025, 3, 1),
    ),
  };

  int _nextNumber = 10003;
  Member? _currentMember;
  bool _isLoading = false;

  Member? get currentMember => _currentMember;
  bool get isLoggedIn => _currentMember != null;
  bool get isLoading => _isLoading;

  /// Returns null on success, or an error message.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));

    final key = email.trim().toLowerCase();
    if (_passwords[key] != password) {
      _setLoading(false);
      return 'Incorrect email or password.';
    }

    _currentMember = _members[key];
    _setLoading(false);
    return null;
  }

  /// Returns null on success, or an error message.
  Future<String?> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));

    final key = email.trim().toLowerCase();
    if (_passwords.containsKey(key)) {
      _setLoading(false);
      return 'An account with this email already exists.';
    }

    final now = DateTime.now();
    final member = Member(
      id: now.millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: key,
      phone: phone.trim(),
      membershipNumber: 'SC-${_nextNumber++}',
      membershipType: MembershipType.basic,
      joinDate: now,
      expiryDate: now.add(const Duration(days: 365)),
    );

    _passwords[key] = password;
    _members[key] = member;
    _currentMember = member;
    _setLoading(false);
    return null;
  }

  /// Returns null on success, or an error message.
  Future<String?> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final current = _currentMember;
    if (current == null) return 'You are not logged in.';

    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));

    final oldKey = current.email;
    final newKey = email.trim().toLowerCase();

    if (newKey != oldKey && _passwords.containsKey(newKey)) {
      _setLoading(false);
      return 'This email is already used by another account.';
    }

    final updated = current.copyWith(
      fullName: fullName.trim(),
      email: newKey,
      phone: phone.trim(),
    );

    // Move the account if the email changed
    if (newKey != oldKey) {
      _passwords[newKey] = _passwords.remove(oldKey)!;
      _members.remove(oldKey);
    }
    _members[newKey] = updated;
    _currentMember = updated;
    _setLoading(false);
    return null;
  }

  void logout() {
    _currentMember = null;
    notifyListeners();
  }
  /// Mock: always succeeds, so the app never reveals which emails
  /// are registered. Backend later: send a reset link to this email.
  Future<void> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}