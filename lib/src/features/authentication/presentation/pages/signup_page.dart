import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/core/utility/widgets/custom_textfield.dart';
import 'package:todo/src/core/utility/widgets/elevated_button.dart';
import 'package:todo/src/core/utility/widgets/outline_button.dart';
import 'package:todo/src/core/utility/widgets/rich_text.dart';
import 'package:todo/src/features/authentication/presentation/bloc/authentication_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state.status == AuthenticationStatus.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup Failed')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'SignUp',
                        style: textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Text('create your Account details',
                          style: textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'satyam.20ch@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: '*******',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      label: 'Confirm Password',
                      hintText: '*******',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        SizedBox(width: 8),
                        Text('OR'),
                        SizedBox(width: 8),
                        Expanded(child: Divider())
                      ],
                    ),
                    const SizedBox(height: 16),
                    const CustomOutlinedButton(
                      logo: 'assets/images/google.png',
                      text: 'Continue with Google',
                    ),
                    const SizedBox(height: 16),
                    const CustomOutlinedButton(
                      logo: 'assets/images/phone.png',
                      text: 'Continue with Mobile',
                    ),
                    const SizedBox(height: 30),
                    CustomElevatedButton(
                      text: 'Continue',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationBloc>().add(
                                CreateAccount(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomRichText(
                      regularText: 'Already have an account? ',
                      clickableText: 'Log In',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
