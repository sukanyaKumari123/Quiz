// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:quizdemo/const/colors.dart';
import 'package:quizdemo/main.dart';
//import 'package:quizdemo/screens/main_menu.dart';

//import 'ui/shared/color.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswer;
  final int incorrectAnswer;
  final int totalQuestions;
  const ResultScreen(
      this.correctAnswer, this.incorrectAnswer, this.totalQuestions,
      {super.key});

  @override
  Widget build(BuildContext context) {
    double correctPercentage = (correctAnswer / totalQuestions * 100);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffa334af), Color.fromARGB(255, 86, 224, 32)])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score is",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "${correctPercentage.toStringAsFixed(1)}%",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Correct Answers ${correctAnswer}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              Text(
                "Incorrect Answers ${incorrectAnswer}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizDemo()));
                  },
                  child: (const Text("BACK TO HOME"))),
            ],
          ),
        ),
      ),
    );
  }
}
