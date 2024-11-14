import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_service_provider_app/screens/home/home_screen.dart';
import 'package:local_service_provider_app/services/auth_service.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/widgets/custom_input.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class HandyManSignUpPage extends StatefulWidget {
  const HandyManSignUpPage({super.key});

  @override
  State<HandyManSignUpPage> createState() => _HandyManSignUpPageState();
}

class _HandyManSignUpPageState extends State<HandyManSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  //signup handyman
  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showDialog("Error", "Passwords do not match");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await AuthService().signUpUser(email: email, password: password);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (error) {
      _showDialog("Error", "Error creating User: $error");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
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
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
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
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
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
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ReusableInput(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                              buttonText: "Sign Up",
                              buttonColor: mainTextColor,
                              buttonTextColor: whiteColor,
                              width: double.infinity,
                              onPressed: _signUpUser,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style:
                                TextStyle(color: mainTextColor, fontSize: 20),
                          ),
                          TextButton(
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: mainTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              GoRouter.of(context).go('/handyman-signin');
                            },
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
