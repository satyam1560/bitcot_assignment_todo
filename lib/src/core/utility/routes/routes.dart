import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:todo/src/features/authentication/presentation/pages/login_page.dart';
import 'package:todo/src/features/authentication/presentation/pages/signup_page.dart';
import 'package:todo/src/features/home/presentation/pages/add_todo.dart';
import 'package:todo/src/features/home/presentation/pages/homepage.dart';

Map<String, WidgetBuilder> appRoutes(BuildContext context) {
  return {
    '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return const HomePage();
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              return const LoginPage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
                
              );
            }
          },
        ),
    '/home': (context) => const HomePage(),
    '/addToDo': (context) => const AddTodoPage(),
    '/signup': (context) => const SignUpPage(),
  };
}
