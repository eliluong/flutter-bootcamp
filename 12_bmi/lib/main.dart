import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double bottomContainerHeight = 60;
// const Color activeCardColor = Color(0xff1d1e33);
const Color inactiveCardColor = Color(0xff1d1e33);
const Color activeCardColor = Color.fromARGB(255, 51, 52, 61);
const TextStyle largeButtonTextStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
const TextStyle titleTextStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
const TextStyle resultTextStyle = TextStyle(color: Color(0xff24d876), fontWeight: FontWeight.bold, fontSize: 32);
const TextStyle bmiTextStyle = TextStyle(fontSize: 100, fontWeight: FontWeight.bold);
const TextStyle guidelineTextStyle = TextStyle(fontSize: 22);

enum Gender {male, female}

void main() => runApp(BMICalculator());
// void main() => runApp(RouteApp());

class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Screen0(),
        '/first': (context) => Screen1(),
        '/second': (context) => Screen2()
      }
    );
  }
}

class Screen0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Screen 0'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Go To Screen 1'),
              onPressed: () {
                Navigator.pushNamed(context, '/first');
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: Text('Go To Screen 2'),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text('screen 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Screen2();
            }));
          },
          child: Text('go to screen2'),
          style: ElevatedButton.styleFrom(primary: Colors.red)
        )
      )
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text('screen 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {Navigator.pop(context);},
          child: Text('go back to screen1'),
          style: ElevatedButton.styleFrom(primary: Colors.blue)
        )
      )
    );
  }
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputPage(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xff0a0e21), secondary: Colors.purple),
      //   scaffoldBackgroundColor: Color(0xff0a0e21),
      //   textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white))
      // )
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff0a0e21),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color(0xff0a0e21)),
      )
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color maleColor = inactiveCardColor;
  Color femaleColor = inactiveCardColor;
  Gender? selectedGender;
  int height = 173;
  int weight = 60;
  int age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('BMI CALCULATOR'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: GenericCard(
                      color: selectedGender == Gender.male ? activeCardColor : inactiveCardColor,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.mars,
                        label: 'MALE',
                      )
                    ),
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: GenericCard(
                      color: selectedGender == Gender.female ? activeCardColor : inactiveCardColor,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.venus,
                        label: 'FEMALE',
                      ),),
                  )
                ),
              ]
            )
          ),
          Expanded(
            child: GenericCard(
              color: inactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('HEIGHT', style: labelTextStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(height.toString(), style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900)),
                      SizedBox(width: 1),
                      Text('cm', style: labelTextStyle)
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Color(0xff8d8e98),
                      thumbColor: Color(0xffeb1555),
                      overlayColor: Color(0x1feb1555),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20)
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                      min: 120,
                      max: 220,
                    ),
                  )
                ],
              ),)
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GenericCard(
                    color: inactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('WEIGHT', style: labelTextStyle,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(weight.toString(), style: labelNumberStyle),
                            SizedBox(width: 1),
                            Text('kg', style: labelTextStyle)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus, 
                              onPress: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus, 
                              onPress: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),)
                ),
                Expanded(
                  child: GenericCard(
                    color: inactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('AGE', style: labelTextStyle),
                        Text(age.toString(), style: labelNumberStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus, 
                              onPress: () {
                                setState(() {
                                  age--;
                                });
                              }
                            ),
                            SizedBox(width: 10),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus, 
                              onPress: () {
                                setState(() {
                                  age++;
                                });
                              }
                            )
                          ]
                        ,)
                      ]
                    ),)
                ),
              ]
            )
          ),
          BottomButton(
            title: 'CALCULATE',
            onTap: () {
              CalculatorBrain calculator = CalculatorBrain(height, weight);

              Navigator.push(
                context, 
                MaterialPageRoute(builder: ((context) => ResultsPage(
                  calculator.calculateBMI(), 
                  calculator.getResult(), 
                  calculator.getGuidelines()))));
            },)
        ],
      ),
    );
  }

  void changeWeight() {
    weight++;
  }

  void updateColor(Gender gender) {
    if (gender == Gender.male) {
      if (maleColor == inactiveCardColor) {
        maleColor = activeCardColor;
        femaleColor = inactiveCardColor;
      } else {
        maleColor = inactiveCardColor;
      }
    } else {
      if (femaleColor == inactiveCardColor) {
        femaleColor = activeCardColor;
        maleColor = inactiveCardColor;
      } else {
        femaleColor = inactiveCardColor;
      }
    }
  }
}

class BottomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  BottomButton({required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(child: Text(this.title, style: largeButtonTextStyle)),
        color: Color(0xffeb1555),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(bottom: 5),
        width: double.infinity,
        height: bottomContainerHeight
      ),
      onTap: onTap,
      // onTap: () {
      //   Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //     return ResultsPage();
      //   })));
      // }
    );
  }
}

const TextStyle labelTextStyle = TextStyle(fontSize: 18, color: Color(0xff8d8e98));
const TextStyle labelNumberStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.w900);

class IconContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize = 80;
  
  IconContent({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: iconSize),
        SizedBox(height: 15),
        Text(label, style: labelTextStyle)
      ],
    );
  }
}

class GenericCard extends StatelessWidget {
  final Color color;
  final Widget cardChild;

  // constructor
  GenericCard({required this.color, required this.cardChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({required this.icon, required this.onPress});

  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: Color(0xff4c4f5e),
        shape: CircleBorder(),
        fixedSize: Size(56, 56),
        elevation: 6
      ),
      child: Icon(icon)
    );
  }
}

class ResultsPage extends StatelessWidget {
  final String bmiResult;
  final String resultText;
  final String guidelineText;

  ResultsPage(this.bmiResult, this.resultText, this.guidelineText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator'), centerTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Text('your results', style: titleTextStyle),
              padding: EdgeInsets.only(left: 15),
              alignment: Alignment.bottomLeft,
            )
          ),
          Expanded(
            flex: 5,
            child: GenericCard(
              color: inactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(resultText.toUpperCase(), style: resultTextStyle),
                  Text(bmiResult, style: bmiTextStyle),
                  Text(guidelineText, style: guidelineTextStyle)
                ],
              ),
            )
          ),
          BottomButton(
            title: 'RECALCULATE',
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }
}

class CalculatorBrain {
  int height;
  int weight;
  double _bmi = 0;

  CalculatorBrain(this.height, this.weight);

  String calculateBMI() {
    print(weight);
    print(height);
    _bmi = weight / pow(height/100, 2);
    print(_bmi);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 25.0) {
      return 'overweight';
    } else if (_bmi > 18.5) {
      return 'normal';
    } else {
      return 'underweight';
    }
  }

  String getGuidelines() {
    if (_bmi >= 25.0) {
      return 'too fat, time to eat less';
    } else if (_bmi > 18.5) {
      return 'you are normal, and boring';
    } else {
      return 'too low, time to eat more';
    }
  }
}