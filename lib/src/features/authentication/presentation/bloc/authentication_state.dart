
part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated,  loading}

class AuthenticationState extends Equatable {
  const AuthenticationState({this.user, required this.status});
  final User? user;
  final AuthenticationStatus status;
  @override
  List<Object?> get props => [user, status];

  factory AuthenticationState.initial() =>
      const AuthenticationState(status: AuthenticationStatus.unauthenticated);

  AuthenticationState copyWith({
    User? user,
    AuthenticationStatus? status,
  }) {
    return AuthenticationState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;
}
