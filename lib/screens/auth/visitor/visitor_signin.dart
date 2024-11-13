import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_provider_app/exceptions/auth_exceptions.dart';
import 'package:local_service_provider_app/screens/auth/visitor/visitor_signup.dart';
import 'package:local_service_provider_app/screens/home/home_screen.dart';
import 'package:local_service_provider_app/screens/services/auth_service.dart';
import 'package:local_service_provider_app/utils/colors.dart';

class VisitorSignInScreen extends StatefulWidget {
  const VisitorSignInScreen({super.key});

  @override
  State<VisitorSignInScreen> createState() => _VisitorSignInScreenState();
}

class _VisitorSignInScreenState extends State<VisitorSignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  //sign in visitor
// Sign in with email and password
 Future<void> _signInUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form validation failed, do not proceed
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Attempt to sign in with email and password
      await AuthService().signInVisitor(email: email, password: password);

      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        // Handle FirebaseAuthException separately
        errorMessage = mapFirebaseAuthExceptionCode(e.code);
      } else {
        // Handle any other exceptions
        errorMessage = 'An unexpected error occurred: $e';
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error signing in: $errorMessage'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Image.asset(
                "assets/images/rb_1123.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                child: Column(
                  key: _formKey,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: mainTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: mainTextColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(22),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainTextColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(22),
                          ),
                        ),
                      ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: mainTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: mainTextColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(22),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainTextColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(22),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainTextColor,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: _signInUser,
                              child:const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: mainTextColor, fontSize: 20),
                        ),
                        TextButton(
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: mainTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            // Navigate to sign in screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VisitorSignupScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
