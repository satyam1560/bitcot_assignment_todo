import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/features/authentication/data/auth_datasource.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthDatasource authDatasource;
  AuthenticationBloc({required this.authDatasource})
      : super(AuthenticationState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<CreateAccount>(_onCreateAccount);
  }
  void _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    final user = authDatasource.getCurrentUser();
    if (user != null) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: user,
        ),
      );
    } else {
      emit(
        state.copyWith(
            status: AuthenticationStatus.unauthenticated, user: null),
      );
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
      ),
    );
    try {
      final user = await authDatasource.loginUser(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            user: user,
          ),
        );
      } else {
        print('Login Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    await authDatasource.signout();
    emit(AuthenticationState.initial());
  }

  void _onCreateAccount(
      CreateAccount event, Emitter<AuthenticationState> emit) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
      ),
    );
    try {
      final user = await authDatasource.createUser(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            user: user,
          ),
        );
      } else {
        print('Account creatin Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
