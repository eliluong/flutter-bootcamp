import 'package:flutter/material.dart';

void main() => runApp(Destini());

class Destini extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StoryPage(),
    );
  }
}

StoryBrain storyBrain = new StoryBrain();

class StoryPage extends StatefulWidget {
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover
          )
        ),
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 12,
                child: Center(
                  child: Text(
                    storyBrain.getStory(),
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      storyBrain.nextStory(1);
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                  child: Text(
                    storyBrain.getChoice1(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 2,
                child: Visibility(
                  visible: storyBrain.buttonVisible(),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        storyBrain.nextStory(2);
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                    child: Text(
                      storyBrain.getChoice2(),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Story {
  late String _storyTitle;
  late String _choice1;
  late String _choice2;

  Story({required String storyTitle, required String choice1, required String choice2}) {
    _storyTitle = storyTitle;
    _choice1 = choice1;
    _choice2 = choice2;
  }
}

class StoryBrain {
  List<Story> _storyData = [
 Story(
     storyTitle:
     'Your car has blown a tire on a winding road in the middle of nowhere with no cell phone reception. You decide to hitchhike. A rusty pickup truck rumbles to a stop next to you. A man with a wide brimmed hat with soulless eyes opens the passenger door for you and asks: "Need a ride, boy?".',
     choice1: 'I\'ll hop in. Thanks for the help!',
     choice2: 'Better ask him if he\'s a murderer first.'),
 Story(
     storyTitle: 'He nods slowly, unphased by the question.',
     choice1: 'At least he\'s honest. I\'ll climb in.',
     choice2: 'Wait, I know how to change a tire.'),
 Story(
     storyTitle:
     'As you begin to drive, the stranger starts talking about his relationship with his mother. He gets angrier and angrier by the minute. He asks you to open the glovebox. Inside you find a bloody knife, two severed fingers, and a cassette tape of Elton John. He reaches for the glove box.',
     choice1: 'I love Elton John! Hand him the cassette tape.',
     choice2: 'It\'s him or me! You take the knife and stab him.'),
 Story(
     storyTitle:
     'What? Such a cop out! Did you know traffic accidents are the second leading cause of accidental death for most adult age groups?',
     choice1: 'Restart',
     choice2: ''),
 Story(
     storyTitle:
     'As you smash through the guardrail and careen towards the jagged rocks below you reflect on the dubious wisdom of stabbing someone while they are driving a car you are in.',
     choice1: 'Restart',
     choice2: ''),
 Story(
     storyTitle:
     'You bond with the murderer while crooning verses of "Can you feel the love tonight". He drops you off at the next town. Before you go he asks you if you know any good places to dump bodies. You reply: "Try the pier".',
     choice1: 'Restart',
     choice2: '')
];
  int _storyNumber = 0;

  String getStory() {
    return _storyData[_storyNumber]._storyTitle;
  }

  String getChoice1() {
    return _storyData[_storyNumber]._choice1;
  }

  String getChoice2() {
    return _storyData[_storyNumber]._choice2;
  }

  void nextStory(int m_choiceNumber) {
    if (_storyNumber == 0) {
      if (m_choiceNumber == 1) { _storyNumber = 2; } else { _storyNumber = 1; }
    } else if (_storyNumber == 1) {
      if (m_choiceNumber == 1) { _storyNumber = 2; } else { _storyNumber = 3; }
    } else if (_storyNumber == 2) {
      if (m_choiceNumber == 1) { _storyNumber = 5; } else { _storyNumber = 4; }
    } else {
      restart();
    }
  }

  void restart() {
    _storyNumber = 0;
  }

  bool buttonVisible() {
    if (_storyNumber == 0 || _storyNumber == 1 || _storyNumber == 2) {
      return true;
    } else {
      return false;
    }
  }

}