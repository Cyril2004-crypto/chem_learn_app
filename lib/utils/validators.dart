class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    final value = v.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? password(String? v, {int minLength = 6}) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < minLength) return 'Password must be at least $minLength characters';
    return null;
  }

  static String? nonEmpty(String? v, {String field = 'Value'}) {
    if (v == null || v.trim().isEmpty) return '$field required';
    return null;
  }

  static String? apiKey(String? v) {
    if (v == null || v.trim().isEmpty) return 'API key required';
    if (v.length < 8) return 'API key seems too short';
    return null;
  }
}