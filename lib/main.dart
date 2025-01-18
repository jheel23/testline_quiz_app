import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF5E6),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const QuizScreen(),
    );
  }
}
