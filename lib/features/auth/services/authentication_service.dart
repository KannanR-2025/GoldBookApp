// Minimal auth stub for backwards compatibility
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUser {
  final String id;
  final String username;
  final String fullName;

  AuthUser({required this.id, required this.username, required this.fullName});
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);

  @override
  String toString() => message;
}

// Simple providers
final authenticationServiceProvider = Provider<dynamic>((ref) => null);
final currentUserProvider = Provider<AuthUser?>((ref) => null);
