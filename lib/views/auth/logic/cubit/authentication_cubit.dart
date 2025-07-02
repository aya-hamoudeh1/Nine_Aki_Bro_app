import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late final StreamSubscription<AuthState> _authSubscription;

  AuthenticationCubit() : super(AuthenticationInitial()) {
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      log('Auth state changed: ${data.event}');
    });
  }

  SupabaseClient client = Supabase.instance.client;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(LoginLoading());
    try {
      final authResponse = await client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (authResponse.user?.emailConfirmedAt == null) {
        emit(LoginError("Please verify your email before logging in."));
        return;
      }
      await _saveLoginInfo(email, rememberMe);
      await getUserData();
      emit(LoginSuccess());
    } on AuthException catch (e) {
      log(e.toString());
      emit(LoginError("Invalid email or password. Please try again."));
    } catch (e) {
      emit(LoginError("An unexpected error occurred."));
    }
  }

  /// Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String ageGroup,
    required Color? skinTone,
  }) async {
    emit(SignUpLoading());
    try {
      await client.auth.signUp(password: password, email: email);
      await _addUserData(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        ageGroup: ageGroup,
        skinTone: skinTone!.toARGB32().toRadixString(16).padLeft(8, '0'),
      );
      emit(SignUpSuccess());
    } on AuthException catch (e) {
      log(e.toString());
      emit(SignUpError(e.message));
    } catch (e) {
      emit(SignUpError("An unexpected error occurred during sign up."));
    }
  }

  /// Google Sign in/up
  Future<void> signInWithGoogle() async {
    try {
      emit(GoogleSignInLoading());
      const webClientId =
          '659973953427-ecfuibhosf579o8vl2s9vb9r6i8aqor3.apps.googleusercontent.com';

      final googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleSignInError(errorMessage: 'Sign in was cancelled.'));
        return;
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw 'Failed to retrieve Google ID token.';

      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final userExists = await _doesUserExist(client.auth.currentUser!.id);
      if (userExists) {
        await getUserData();
        emit(GoogleSignInSuccess());
      } else {
        emit(
          GoogleSignInNeedsProfileCompletion(
            email: googleUser.email,
            name: googleUser.displayName,
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      emit(
        GoogleSignInError(
          errorMessage: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    emit(LogoutLoading());
    try {
      await client.auth.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      log(e.toString());
      emit(LogoutError());
    }
  }

  /// Reset Password
  Future<void> resetPassword({required String email}) async {
    emit(PasswordResetLoading());
    try {
      await client.auth.resetPasswordForEmail(email);
      emit(PasswordResetSuccess());
    } catch (e) {
      log(e.toString());
      emit(PasswordResetError());
    }
  }

  ///  Add User data
  Future<void> _addUserData({
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required String ageGroup,
    required String skinTone,
  }) async {
    try {
      await client.from('users').upsert({
        'user_id': client.auth.currentUser!.id,
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'address': address,
        'age_group': ageGroup,
        'skin_tone': skinTone,
      });
    } catch (e) {
      log('Error adding user data: $e');
      throw Exception('Failed to add user data.');
    }
  }

  /// Get User Data
  UserDataModel? userDataModel;
  Future<void> getUserData() async {
    try {
      final data =
          await client
              .from('users')
              .select()
              .eq('user_id', client.auth.currentUser!.id)
              .single();

      userDataModel = UserDataModel.fromMap(data);
    } catch (e) {
      log('Get User Data Error: $e');
      userDataModel = null;
    }
  }

  /// Does User Exist
  Future<bool> _doesUserExist(String userId) async {
    try {
      final response =
          await client
              .from('users')
              .select()
              .eq('user_id', userId)
              .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Save Login Info
  Future<void> _saveLoginInfo(String email, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', email);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('remember_me');
    }
  }

  /// Get Login Info
  Future<Map<String, dynamic>> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('saved_email');
    final rememberMe = prefs.getBool('remember_me') ?? false;
    return {'email': email, 'remember_me': rememberMe};
  }
}
