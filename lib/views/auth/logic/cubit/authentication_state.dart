part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

/// Login
final class LoginSuccess extends AuthenticationState {}

final class LoginLoading extends AuthenticationState {}

final class LoginError extends AuthenticationState {
  final String message;
  LoginError(this.message);
}

/// Sign Up
final class SignUpSuccess extends AuthenticationState {}

final class SignUpLoading extends AuthenticationState {}

final class SignUpError extends AuthenticationState {
  final String message;
  SignUpError(this.message);
}

/// Google sign in / up
final class GoogleSignInSuccess extends AuthenticationState {}

final class GoogleSignInLoading extends AuthenticationState {}

final class GoogleSignInNeedsProfileCompletion extends AuthenticationState {
  final String email;
  final String? name;

  GoogleSignInNeedsProfileCompletion({required this.email, this.name});
}

final class GoogleSignInError extends AuthenticationState {
  final String errorMessage;
  GoogleSignInError({required this.errorMessage});
}

/// Logout
final class LogoutSuccess extends AuthenticationState {}

final class LogoutLoading extends AuthenticationState {}

final class LogoutError extends AuthenticationState {}

/// PasswordReset
final class PasswordResetSuccess extends AuthenticationState {}

final class PasswordResetLoading extends AuthenticationState {}

final class PasswordResetError extends AuthenticationState {}

/// Add User data
final class UserDataAddedSuccess extends AuthenticationState {}

final class UserDataAddedLoading extends AuthenticationState {}

final class UserDataAddedError extends AuthenticationState {}

/// Get User data
final class GetUserDataSuccess extends AuthenticationState {}

final class GetUserDataLoading extends AuthenticationState {}

final class GetUserDataError extends AuthenticationState {}
