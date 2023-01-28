import 'package:flutter/material.dart';
import 'package:todoapp/app/app.dart';
import 'package:todoapp/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(() => const App());
}
