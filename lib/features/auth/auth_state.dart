import 'package:showave/models/user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated({required this.user});
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError({required this.message});
}
