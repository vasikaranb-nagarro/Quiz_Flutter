import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_bloc.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserAuthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(state.user.uid,
                        state.user.email ?? "", state.profilePictureUrl ?? "")),
                (route) => false,
              );
            } else if (state is UserInitial) {
              // Authentication failed
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Authentication Failed'),
                  content: Text(
                       'Invalid credentials. Please try again.'),
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
                      UserLogin(
                          _emailController.text, _passwordController.text),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
