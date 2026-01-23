import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier() : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  final AuthService _authService = AuthService();

  Future<void> _loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final data = await _authService.getUserProfile(user.uid);
      if (data != null) {
        state = AsyncValue.data(UserProfile.fromJson(data));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }
  
  void clear() {
    state = const AsyncValue.data(null);
  }
}
