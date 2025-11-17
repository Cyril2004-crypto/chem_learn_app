import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  AppUser? _user;

  AuthProvider(this._authService);

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> loadCurrentUser() async {
    final u = await _authService.currentUser();
    _user = u;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final u = await _authService.signIn(email, password);
    _user = u;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, {String? displayName}) async {
    final u = await _authService.signUp(email, password, displayName: displayName);
    _user = u;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}