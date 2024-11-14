import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_service_provider_app/exceptions/auth_exceptions.dart';
import 'package:local_service_provider_app/services/auth_service.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/widgets/custom_input.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class HandyManSignIn extends StatefulWidget {
  const HandyManSignIn({super.key});

  @override
  State<HandyManSignIn> createState() => _HandyManSignInState();
}

class _HandyManSignInState extends State<HandyManSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signInUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await AuthService().signInUser(email: email, password: password);
      _showSnackbar("Success", "Signed in successfully");

      if (mounted) {
        GoRouter.of(context).go('/home');
      }
    } catch (e) {
      String errorMessage = 'An unexpected error occurred.';
      if (e is FirebaseAuthException) {
        errorMessage = mapFirebaseAuthExceptionCode(e.code);
      }
      _showSnackbar("Error", "Error signing in: $errorMessage");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String title, String message) {
    final snackBar = SnackBar(content: Text("$title: $message"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/rb_7853.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ReusableInput(
                        controller: _emailController,
                        labelText: "Email",
                        icon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      ReusableInput(
                        controller: _passwordController,
                        labelText: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                              buttonText: "Sign In",
                              buttonColor: mainTextColor,
                              buttonTextColor: whiteColor,
                              width: double.infinity,
                              onPressed: _signInUser,
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style:
                                TextStyle(color: mainTextColor, fontSize: 20),
                          ),
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).push('/handyman-signup');
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: mainTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
