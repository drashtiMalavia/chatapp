//Loginscreen
import 'dart:io';

import 'package:chatapp/helper/dailogs.dart';
import 'package:chatapp/modelclass/UsermodelClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../HomeScreen.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Login Page'),
            centerTitle: true,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                child: Lottie.asset('animation/g.json'),
                height: double.infinity,
                width: double.infinity,
              ),
              Positioned(
                top: 600,
                left: 125,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      overlayColor: Colors.black,
                      shape: StadiumBorder(),
                      elevation: 1
                  ),
                  onPressed: () {
                    Login();
                  },
                  icon: Icon(Icons.g_mobiledata_rounded,color: Colors.green,),
                  label: Text('Log in with goggle'),
                ),
              ),
            ],
          ),
        )
    );
  }


  Future<UserCredential?> signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch(e){
      Dialogs.showSneckBar(context, 'something went wrong Please check your internet');
      return null;
    }
  }
  void Login(){
    signInWithGoogle().then((value) async {
      // print('\nuser${value.user}');
      // print('\nuser:${value.additionalUserInfo}');
      if(value?.user!=null){
        if((await IsUserExist())){
          Navigator.push(context,MaterialPageRoute(builder: (context) {
            return HomeScreen();
          },));
        }
        else{
          await CreateUser().then((value) {
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return HomeScreen();
            },));
          },);
        }
      }
    },);
  }
  Future<bool> IsUserExist() async {
    return (
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get()
    ).exists;
  }
  Future<void> CreateUser() async {
    final getuser=FirebaseAuth.instance.currentUser!;
    final time=DateTime.now().microsecondsSinceEpoch.toString();
    final user=UsermodelClass(
        image: getuser.photoURL.toString(),
        about: 'Heyy alwasy happy',
        name: getuser.displayName.toString(),
        createdAt: time,
        id: getuser.uid,
        lastActive: time,
        isOnline: false,
        email: getuser.email.toString(),
        pushToken: ''
    );
    return await FirebaseFirestore.instance.collection('users').doc(getuser.uid).set(user.toJson());
  }
}
