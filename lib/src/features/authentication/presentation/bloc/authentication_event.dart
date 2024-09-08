part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}


class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String email;
  final String password;

  const LoggedIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoggedOut extends AuthenticationEvent {}

class CreateAccount extends AuthenticationEvent {
  final String email;
  final String password;

  const CreateAccount(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
