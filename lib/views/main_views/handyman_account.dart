import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/utils/functions.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();
  bool _isLoading = false;

  // Function to update the email
  Future<void> _updateEmail() async {
    try {
      setState(() => _isLoading = true);

      var user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await user.verifyBeforeUpdateEmail(_emailController.text.trim());
      await user.reload();
      user = FirebaseAuth
          .instance.currentUser; // Reload user to get the updated data

      if (mounted) {
        UtilFuctions().showSnackBar(context, "Email updated successfully");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Function to update the password
  Future<void> _updatePassword() async {
    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      if (_newPasswordController.text != _newPasswordConfirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      await user.updatePassword(_newPasswordController.text.trim());
      if (mounted) {
        UtilFuctions().showSnackBar(context, "Password updated successfully");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: mainTextColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        const InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordConfirmController,
                    decoration: const InputDecoration(
                        labelText: 'Confirm New Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  ReusableButton(
                    buttonText: 'Update Email',
                    buttonColor: mainTextColor,
                    buttonTextColor: whiteColor,
                    onPressed: _updateEmail,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  ReusableButton(
                    buttonText: 'Update Password',
                    buttonColor: mainTextColor,
                    buttonTextColor: whiteColor,
                    onPressed: _updatePassword,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
    );
  }
}
