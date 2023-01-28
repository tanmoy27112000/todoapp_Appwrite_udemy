// ignore_for_file: use_build_context_synchronously, inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:todoapp/app/view/app.dart';
import 'package:todoapp/home/view/home_page.dart';
import 'package:todoapp/login/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getSessionDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Todo app'),
      ),
    );
  }

  Future<void> getSessionDetails() async {
    await prefs.init();
    final sessionId = prefs.getSessionId();
    if (sessionId.isEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    }
  }
}
