import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showave/models/user.dart';

final profileProvider = FutureProvider<User>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final user = User.fromJson(
    jsonDecode(prefs.getString("user_data")!) as Map<String, dynamic>,
  );
  return user;
});
