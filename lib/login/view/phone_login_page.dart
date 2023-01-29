// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:todoapp/app/app.dart';
import 'package:todoapp/helper/auth_helper.dart';
import 'package:todoapp/home/home.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String userId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (phoneController.text.isNotEmpty) {
                        // Add code to send OTP
                        userId = await AuthHelper()
                            .loginWithNumber('+91${phoneController.text}');
                      }
                    } catch (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error sending OTP'),
                        ),
                      );
                    }
                  },
                  child: const Text('Send OTP'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: otpController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your OTP',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your OTP';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (otpController.text.isNotEmpty) {
                  await AuthHelper()
                      .verifyOTP(userId: userId, otp: otpController.text)
                      .then((value) {
                    prefs.setSessionId(value.$id);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    debugPrint(error.toString());
                  });
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
