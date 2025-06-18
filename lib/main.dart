import 'package:cardio_care/routes.dart';
import 'package:cardio_care/screens/home/patient/patient_dashbaord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthRepository _authRepository = AuthRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(authRepository: _authRepository)..add(AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'RedditSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: routes,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(authRepository: _authRepository)..add(AppStarted()),
      child: MaterialApp(
        title: 'Flutter Firebase Auth with BLoC',
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              debugPrint("AuthAuthenticated..");
              return const PatientDashboard(); // your dashboard screen
            } else if (state is AuthUnauthenticated) {
              debugPrint("AuthUnauthenticated..");
              return LoginScreen();
            } else if (state is AuthLoading) {
              debugPrint("AuthLoading..");
              return const Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        ),
      ),
    );
  }
}
