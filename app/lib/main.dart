import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  final userGetName = sharedPreferences?.getString('USERNAME');
  runApp(MaterialApp(
      home: MyApp(
    username: userGetName,
  )));
}

class MyApp extends StatelessWidget {
  String? _username;
  String? _password;
  final _formKey = GlobalKey<FormState>();

  final String? username;

  MyApp({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return username != null
        ? LoggedScreen(
            username: username,
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Username'),
                      validator: (username) {
                        if (username == null || username.isEmpty) {
                          return 'Write username';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (username) => _username = username,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Password'),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Write password';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (password) => _password = password,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            await sharedPreferences?.setString(
                                'USERNAME', _username.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LoggedScreen(username: _username),
                              ),
                            );
                          }
                        },
                        child: const Text('ACCESS')),
                  ],
                ),
              ),
            ),
          );
  }
}

class LoggedScreen extends StatelessWidget {
  final String? username;
  const LoggedScreen({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$username Logged In'),
      ),
    );
  }
}
