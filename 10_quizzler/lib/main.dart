import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();
void main() {
  runApp(Quizzler());
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text('true or false?'),
          backgroundColor: Colors.grey.shade800,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: QuizPage(),
          )
        )
      )
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Icon> scoreKeeper = [Icon(Icons.alarm, color: Colors.black.withOpacity(0))];
  
  void checkAnswer(bool userAnswer) {
    setState(() {
      // allows scoreKeeper row to persist with transparent icon that is removed later
      if (scoreKeeper[0].icon == Icons.alarm) {
        scoreKeeper.removeAt(0);
      }

      if (userAnswer == quizBrain.getQuestionAnswer()) {
        scoreKeeper.add(
          Icon(Icons.check, color: Colors.green)
        );
      } else {
        scoreKeeper.add(
          Icon(Icons.close, color: Colors.red)
        );
      }

      if (quizBrain.lastQuestion()) {
        // calculate the score
        int finalScore;



        Alert(
          context: context,
          title: 'true or false?',
          desc: 'you finished the damn quiz'
        ).show();
        scoreKeeper = [Icon(Icons.alarm, color: Colors.black.withOpacity(0))];
      }

      quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
        //TODO: Add a Row here as your score keeper
      ],
    );
  }
}

class Question {
  late String questionText;
  late bool questionAnswer;

  Question(this.questionText, this.questionAnswer);
}

class QuizBrain {
  List<Question> _questionBank = [
    Question('is Ilan smart?', true),
    Question('is Ilan crazy?', false),
    Question('is Jeff smart?', true),
    Question('is Ilan clever?', true),
    Question('does Jeff have a macbook?', true),
    Question('is Kevin a double-agent spy?', true)
  ];
  int _questionNumber = 0;

  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    } else {
      _questionNumber = 0;
    }
  }

  bool lastQuestion() {
    if (_questionNumber == (_questionBank.length - 1)) {
      return true;
    } else {
      return false;
    }
  }

  int getNumberQuestions() {
    return _questionBank.length;
  }
}