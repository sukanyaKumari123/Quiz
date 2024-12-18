// ignore_for_file: use_super_parameters, unused_import, prefer_const_constructors, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizdemo/api_services.dart';
import 'package:quizdemo/const/colors.dart';
import 'package:quizdemo/const/images.dart';
import 'package:quizdemo/const/text_style.dart';
import 'package:quizdemo/result.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future quiz;
  int second = 30;
  var currentIndexOfQuestion = 0;
  Timer? timer;
  bool isLoading = false;
  var optionlist = [];
  int correctAnswer = 0;
  int incorrectAnswer = 0;

  var optionColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  resetColor() {
    optionColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (second > 0) {
          second--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    setState(() {
      isLoading = false;
      currentIndexOfQuestion++;
      timer!.cancel();
      second = 30;
      startTimer();
      resetColor();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder(
            future: quiz,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "ERROR:${snapshot.error}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data["results"];
                if (isLoading == false) {
                  optionlist =
                      data[currentIndexOfQuestion]['incorrect_answers'];
                  optionlist
                      .add(data[currentIndexOfQuestion]['correct_answer']);
                  optionlist.shuffle();
                  isLoading = true;
                }
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                )),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "$second",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  value: second / 20,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Center(
                          child: Image(image: AssetImage('assets/img_1.png'))),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Center(
                          child: Text(
                            "Question ${currentIndexOfQuestion + 1} of ${data.length}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          data[currentIndexOfQuestion]['question'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: optionlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            var correctanswer =
                                data[currentIndexOfQuestion]['correct_answer'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (correctanswer.toString() ==
                                      optionlist[index].toString()) {
                                    optionColor[index] = Colors.green;
                                    correctAnswer++;
                                  } else {
                                    optionColor[index] = Colors.red;
                                    incorrectAnswer++;
                                  }
                                  if (currentIndexOfQuestion <
                                      data.length - 1) {
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      gotoNextQuestion();
                                    });
                                  } else {
                                    timer!.cancel();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultScreen(
                                                correctAnswer,
                                                incorrectAnswer,
                                                currentIndexOfQuestion + 1)));
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width - 100,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: optionColor[index],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  optionlist[index].toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ));
              } else {
                return const Center(
                  child: Text("NO DATA FOUND"),
                );
              }
            }),
      ),
    );
  }
}
