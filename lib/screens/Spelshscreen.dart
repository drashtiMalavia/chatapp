import 'package:chatapp/screens/auth/loginscreen.dart';
import 'package:chatapp/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Spelshscreen extends StatefulWidget {
  const Spelshscreen({super.key});

  @override
  State<Spelshscreen> createState() => _SpelshscreenState();
}

class _SpelshscreenState extends State<Spelshscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MoveScreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Lottie.asset('animation/l.json'),
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  void MoveScreen() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      if(FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomeScreen();
        },));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        },));
      }

    },);
  }
}
