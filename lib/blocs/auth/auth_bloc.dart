import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      debugPrint("Started..");
      emit(AuthLoading());
      final user = FirebaseAuth.instance.currentUser;
      print("app started $user");
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      debugPrint("loading..");
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        debugPrint("call end----..");
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Login failed'));
        }
      } catch (e) {
        debugPrint("error.. ${e.toString()}");
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.register(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Registration failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}
