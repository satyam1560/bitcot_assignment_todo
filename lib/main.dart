import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/src/core/utility/routes/routes.dart';
import 'package:todo/src/features/authentication/data/auth_datasource.dart';
import 'package:todo/src/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:todo/src/features/home/data/datasources/todo_datasource.dart';
import 'package:todo/src/features/home/presentation/bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authDatasource: AuthDatasource(firebaseAuth: FirebaseAuth.instance),
          )..add(AppStarted()),
        ),
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(
            todoDatasource: TodoDatasource(
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Authentication',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: appRoutes(context),
      ),
    );
  }
}
