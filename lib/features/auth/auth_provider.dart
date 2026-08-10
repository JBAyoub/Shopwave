import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showave/core/constants.dart';
import 'package:showave/core/dio_client.dart';
import 'package:showave/features/auth/auth_state.dart';
import 'package:showave/models/user.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthStateInitial();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(AppConstants.tokenKey);
    if (savedToken == null) return;
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        AppConstants.profileRoute,
        options: Options(headers: {'Authorization': 'Bearer $savedToken'}),
      );
      final user = User.fromJson(response.data['user'] as Map<String, dynamic>);
      state = AuthStateAuthenticated(user);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthStateLoading();
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post(
        AppConstants.loginRoute,
        data: {'email': email.trim(), 'password': password},
      );
      final user = User.fromJson(response.data as Map<String, dynamic>);
      await _saveSession(user);
      state = AuthStateAuthenticated(user);
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map<String, dynamic>
          ? data['message'] as String? ??
                _httpErrorMessage(e.response?.statusCode)
          : data is String
          ? data
          : _httpErrorMessage(e.response?.statusCode);
      state = AuthStateError(message);
    } catch (_) {
      state = const AuthStateError('An unexpected error occurred.');
    }
  }

  Future<void> logout() async {
    await _clearSession();
    state = AuthStateInitial();
    ref.invalidate(authProvider);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove("user_data");
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, user.token);
    await prefs.setString(AppConstants.userIdKey, user.id);
    await prefs.setString("user_data", jsonEncode(user.toJson()));
  }

  String _httpErrorMessage(int? code) => switch (code) {
    400 => 'Bad request. Please check your input.',
    401 => 'Incorrect Email or Password. Please check your credentials.',
    403 => 'Forbidden. You do not have access.',
    429 => 'Too many requests. Try again later.',
    404 => 'Not found. The resource does not exist.',
    500 => 'Server error. Please try again later.',
    _ => 'An unexpected error occurred. Please try again.',
  };
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
