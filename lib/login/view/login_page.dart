import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/app/view/app.dart';
import 'package:todoapp/helper/auth_helper.dart';
import 'package:todoapp/home/home.dart';
import 'package:todoapp/login/view/phone_login_page.dart';
import 'package:todoapp/signup/signup.dart';
import 'package:todoapp/util/regex.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  SignUpModel model = SignUpModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                child: const Text('Login'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    await AuthHelper()
                        .loginUserWithEmail(
                      email: model.email!,
                      password: model.password!,
                    )
                        .then((value) {
                      prefs.setSessionId(value.$id);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Homepage(),
                        ),
                      );
                    }).onError((error, stackTrace) {
                      print(error);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
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
                    child: const Text('Login with Google'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/todos');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Login with Apple'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/todos');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      AuthHelper().loginAnnonymously().then((value) {
                        prefs.setSessionId(value.$id);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Homepage(),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    child: const Text('Login annonymously'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhoneLoginPage(),
                        ),
                      );
                    },
                    child: const Text('Login with phone'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
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
