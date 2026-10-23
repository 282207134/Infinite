import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'app/app_controller.dart';
import 'data/local_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  final preferences = await SharedPreferences.getInstance();
  runApp(InfiniteApp(controller: AppController(LocalRepository(preferences))));
}
