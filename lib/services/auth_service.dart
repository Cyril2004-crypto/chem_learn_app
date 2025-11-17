import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user.dart';
import 'secure_storage_service.dart';

class AuthService {
  final SecureStorageService _storage = SecureStorageService();

  static const _userPrefix = 'user_'; // keyed by email: user_<email> -> hashedPassword
  static const _authEmailKey = 'auth_user_email';
  static const _authIdKey = 'auth_user_id';

  Future<AppUser?> currentUser() async {
    final email = await _storage.read(_authEmailKey);
    final id = await _storage.read(_authIdKey);
    if (email == null || id == null) return null;
    return AppUser(id: id, email: email, displayName: null);
  }

  Future<AppUser> signUp(String email, String password, {String? displayName}) async {
    final key = '$_userPrefix${email.toLowerCase()}';
    final existing = await _storage.read(key);
    if (existing != null) {
      throw Exception('User already exists');
    }
    final hashed = _hash(password);
    await _storage.write(key, hashed);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(_authEmailKey, email);
    await _storage.write(_authIdKey, id);
    return AppUser(id: id, email: email, displayName: displayName);
  }

  Future<AppUser> signIn(String email, String password) async {
    final key = '$_userPrefix${email.toLowerCase()}';
    final storedHash = await _storage.read(key);
    if (storedHash == null) throw Exception('No such user');
    final hashed = _hash(password);
    if (storedHash != hashed) throw Exception('Invalid credentials');
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(_authEmailKey, email);
    await _storage.write(_authIdKey, id);
    return AppUser(id: id, email: email, displayName: null);
  }

  Future<void> signOut() async {
    await _storage.delete(_authEmailKey);
    await _storage.delete(_authIdKey);
  }

  String _hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}