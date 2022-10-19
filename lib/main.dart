import 'package:flutter/material.dart';
import 'package:translator_app/config/presentation/app_color.dart';
import 'package:translator_app/config/route.dart';
import 'package:translator_app/translation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: AppColor.primarySwatch,
      ),
      home: const TranslationPage(),
    );
  }
}