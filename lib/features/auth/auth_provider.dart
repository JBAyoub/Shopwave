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
      state = AuthStateAuthenticated(user: user);
    } catch (e) {
      state = AuthStateError(message: e.toString());
    }
  }
}
