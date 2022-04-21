// ignore_for_file: unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash_chat/screens/welcome_screen.dart';
// import 'package:flash_chat/screens/login_screen.dart';
// import 'package:flash_chat/screens/registration_screen.dart';
// import 'package:flash_chat/screens/chat_screen.dart';

// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      // home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen()
      }
    );
  }
}

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

late User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final msgTextController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  // late User loggedInUser;
  late String theUser = '';
  late String messageInput;

  @override
  void initState() {
    getUser();
    super.initState();
    // if (listScrollController.hasClients) {
    //   final position = listScrollController.position.maxScrollExtent;
    //   listScrollController.jumpTo(position);
    // }
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) { // make sure user is not null
        loggedInUser = user;
        print('logged in: ${loggedInUser.email}');
        setState(() {
          theUser = loggedInUser.email.toString();
        });
      }
    } catch(e) {
      print('getUser() error: $e');
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var msg in messages.docs) {
      print(msg.data());
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat    [$theUser]'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) { // make sure snapshot not empty
                  final msgs = snapshot.data!.docs; // all documents
                  List<MessageBubble> msgWidgets = [];
                  for (var msg in msgs) { // one document
                    final Map<String, dynamic> temp = msg.data()! as Map<String, dynamic>;
                    final text = msg.get('msg');// temp['msg'];
                    final sender = msg.get('sender');// temp['sender'];

                    // if (theUser == sender)

                    msgWidgets.add(MessageBubble(
                      text: text, 
                      sender: sender, 
                      isSelf: theUser == sender,));
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      controller: listScrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      children: msgWidgets,
                    ),
                  );
                } else { // show spinner while waiting for data
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    )
                  );
                }
                // return Column(
                //   children: [Text('error: no messages to display')],
                // );
              }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        messageInput = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      style: TextStyle(color: Colors.grey[900])
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      msgTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'msg': messageInput,
                        'timestamp': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              AppField(
                fieldHint: 'Enter your email',
                fieldFunction: (value) {
                  email = value;
                },
                isEmailAddress: true,
              ),
              SizedBox(
                height: 8.0,
              ),
              AppField(
                fieldHint: 'Enter your password', 
                fieldFunction: (value) {
                  password = value;
                },
                isPassword: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              AppButton(
                buttonText: 'Log In', 
                buttonColor: Colors.lightBlueAccent,
                buttonAction: () async {
                  // print('logging in');
                  try {
                    context.loaderOverlay.show();
                    await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                    print('logging in');
                  } on FirebaseAuthException catch (e) {
                    print('registration error: $e.code');
                  } catch(e) {
                    print('other registration error: $e');
                  }
                  context.loaderOverlay.hide();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  static const String id = 'reg';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              AppField(
                fieldHint: 'Enter your email',
                fieldFunction: (value) {
                  email = value;
                },
                isEmailAddress: true,
              ),
              SizedBox(
                height: 8.0,
              ),
              AppField(
                fieldHint: 'Enter your password', 
                fieldFunction: (value) {
                  password = value;
                },
                isPassword: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              AppButton(
                buttonText: 'Register', 
                buttonColor: Colors.blueAccent,
                buttonAction: () async {
                  print('registering: $email, $password');
                  try {
                    context.loaderOverlay.show();
                    final newUser = await _auth.createUserWithEmailAndPassword(
                                                email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                  } on FirebaseAuthException catch (e) {
                    print('registration error: $e.code');
                  } catch(e) {
                    print('other registration error: $e');
                  }
                  context.loaderOverlay.hide();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  late String fieldHint;
  late Function(String) fieldFunction;
  late bool isPassword;
  late bool isEmailAddress;

  AppField({required this.fieldHint, 
      required this.fieldFunction, 
      this.isPassword = false,
      this.isEmailAddress = false});

  @override
  Widget build(BuildContext context) {
    print('isPassword: $isPassword');
    return TextField(
      keyboardType: isEmailAddress ? TextInputType.emailAddress : TextInputType.text,
      obscureText: isPassword,
      onChanged: fieldFunction,
      decoration: kTextFieldDecoration.copyWith(
        hintText: fieldHint
      ),
      style: TextStyle(
        color: Colors.black87
      ),
      textAlign: TextAlign.center,
    );
  }
}

class Animal {
  void move() { print('changed position'); }
}

class Fish extends Animal { // inheritance
  @override void move() { // use parent move(), but add more
    super.move();
    print('by swimming');
  }
}

class Bird extends Animal {
  @override void move() {
    super.move();
    print('by flying');
  }
}

mixin CanSwim {
  void swim() { print('changing position by swimming'); }
}

mixin CanFly {
  void fly() { print('changing position by flying'); }
}

// duck can swim and fly (in addition to move)
class Duck extends Animal with CanSwim, CanSwim {}

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> 
      with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blueGrey, end: Colors.white
    ).animate(controller);
    // animation = CurvedAnimation(
    //   parent: controller, curve: Curves.decelerate);

    controller.forward();

    // infinitely looping animation via status listeners
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {  });

      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: 60.0,
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            AppButton(
              buttonText: 'Log In', 
              buttonColor: Colors.lightBlueAccent,
              buttonAction: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            AppButton(
              buttonText: 'Register',
              buttonColor: Colors.blueAccent,
              buttonAction: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  late String buttonText;
  late Color buttonColor;
  late VoidCallback buttonAction;

  AppButton({required this.buttonText, required this.buttonColor, required this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: buttonAction,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isSelf;

  MessageBubble({required this.text, required this.sender, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54
            )
          ),
          SizedBox(height: 3),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isSelf ? Radius.circular(30) : Radius.zero, 
              topRight: isSelf ? Radius.zero : Radius.circular(30),
              bottomLeft: Radius.circular(30), 
              bottomRight: Radius.circular(30)),
            color: isSelf ? Colors.lightBlueAccent : Colors.grey[200],
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelf ? Colors.white : Colors.black54
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter user input',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding:
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
