import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/helper/auth_helper.dart';
import 'package:todoapp/home/view/home_page.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/util/regex.dart';



class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final formKey = GlobalKey<FormState>();

  SignUpModel model = SignUpModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Signup',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Name'),
                  hintText: 'Enter your Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) => model.name = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Email'),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) => model.email = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Password'),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) => model.password = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!passwordRegex.hasMatch(value)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: const Text('Signup'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      await AuthHelper()
                          .createUserWithEmail(
                            email: model.email!,
                            password: model.password!,
                            name: model.name!,
                          )
                          .then(
                            (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Homepage(),
                              ),
                            ),
                          );
                    } catch (e) {
                      //snackbar
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    color: Colors.black,
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('OR'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    color: Colors.black,
                    height: 1,
                  ),
                ],
              ),
              //signup with google
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Signup with Google'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/todos');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Signup with Apple'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/todos');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
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
  }
}

class SignUpModel {
  SignUpModel({this.email, this.password});
  String? email;
  String? name;
  String? password;
}
