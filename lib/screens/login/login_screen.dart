import 'package:cardio_care/classes/check_internet.dart';
import 'package:cardio_care/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../signup/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  final formKey = GlobalKey<FormState>();

  late BuildContext _ctx;

  void _submit() {
    final form = formKey.currentState;
    FocusScope.of(_ctx).unfocus();
    if (form!.validate()) {
      hasInternetAccess().then((result) {
        if (result) {
          _showSnackBar("validating!");
          form.save();
          _showSnackBar("validated!");
        } else {
          _showSnackBar("Check your internet connectivity!");
        }
      });
    }
  }

  void _showSnackBar(String text) {
    var snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2), // Optional
      action: SnackBarAction(
        label: 'CLOSE',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(_ctx).showSnackBar(snackBar);
  }

  void _validateAndLogin() async {
    final hasInternet = await hasInternetAccess();
    final form = formKey.currentState;

    if (hasInternet) {
      _showSnackBar("Validating...");
      form?.save();

      await Future.delayed(Duration(milliseconds: 500)); // Optional delay
      _showSnackBar("Validated!");

      context.read<AuthBloc>().add(
            AuthLoginRequested(
              emailController.text.trim(),
              passwordController.text.trim(),
            ),
          );
    } else {
      _showSnackBar("Check your internet connectivity!");
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    double containerHeight = size.height * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFF9771), // Peach
              Color(0xFFEC3D41), // Red-pink
            ],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              print("loggedin");
              Navigator.pushReplacementNamed(context, '/patient');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      // Top SVG/Logo
                      SvgPicture.asset(
                        'assets/images/logo.svg', // Make sure this path matches your asset
                        width: size.width * 0.3,
                      ),
                      SizedBox(height: 32),

                      // Container with rounded white background
                      Container(
                        width: double.infinity,
                        height: containerHeight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 32.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Color.fromARGB(255, 51, 65, 85),
                                    fontFamily: 'RedditSans',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                // if (value.length < 6) {
                                //   return 'Password must be at least 6 characters long';
                                // }
                                // // Regular expression to check for alphanumeric and at least one symbol
                                // RegExp regex = RegExp(
                                //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$');

                                // if (!regex.hasMatch(value)) {
                                //   return 'Password must contain letters, numbers, and a special character';
                                // }
                                return null;
                              },
                            ),
                            // const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 49, 112, 175),
                                      fontFamily: 'RedditSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      FocusScope.of(_ctx).unfocus();
                                      final form = formKey.currentState;
                                      if (form!.validate()) {
                                        // Mark the function as async
                                        () async {
                                          final result =
                                              await hasInternetAccess();
                                          if (!mounted) return;

                                          if (result) {
                                            context.read<AuthBloc>().add(
                                                  AuthLoginRequested(
                                                    emailController.text.trim(),
                                                    passwordController.text
                                                        .trim(),
                                                  ),
                                                );
                                          } else {
                                            _showSnackBar(
                                                "Check your internet connectivity!");
                                          }
                                        }(); // Immediately invoke the async function
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xFFEC3D41),
                                foregroundColor: Colors.white,
                              ),
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'RedditSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
