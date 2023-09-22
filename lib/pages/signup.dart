import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserAuthenticated) {
              // Successfully signed up
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('SignUp Success'),
                  content: const Text(
                      'Registration successful. Please login to continue'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else if (state is UserInitial) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('SignUp Failed'),
                  content:
                      Text( 'Unknown Error. Please try again.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<UserBloc>(context).add(
                      UserSignup(
                          _emailController.text, _passwordController.text),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
