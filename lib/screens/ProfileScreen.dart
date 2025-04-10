import 'dart:io';

import 'package:chatapp/helper/dailogs.dart';
import 'package:chatapp/screens/auth/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../modelclass/UsermodelClass.dart';

class Profilescreen extends StatefulWidget {
  final UsermodelClass usermodelClass;
  Profilescreen({super.key, required this.usermodelClass});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final formKey=GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Profile Screen'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _image == null?Padding(
                        padding: const EdgeInsets.all(20.0), // Add padding around the ClipOval
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipOval(
                            child: Image.network(
                              '${widget.usermodelClass.image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.all(20.0), // Add padding around the ClipOval
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipOval(
                            child: Image.file(File(_image!),fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {

                            });
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                                )
                              ),
                              builder: (context) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 40,bottom: 50),
                                  children: [
                                    Text('Pick profile picture',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                    SizedBox(height: 30,),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            fixedSize: Size(150, 150)
                                          ),
                                            onPressed: () async {

                                              final ImagePicker picker = ImagePicker();
                                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                              if(image!=null){
                                                setState(() {
                                                  _image=image.path;
                                                });
                                                Navigator.pop(context);
                                              }

                                            },
                                            child: Image.asset('images/add_image.png'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              fixedSize: Size(150, 150)
                                          ),
                                          onPressed: () {

                                          },
                                          child: Image.asset('images/camera.png'),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.edit),
                          elevation: 1,
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('${widget.usermodelClass.email}',style: TextStyle(fontSize: 25),),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: widget.usermodelClass.name,
                      onSaved: (newValue) => widget.usermodelClass.name=newValue ?? '',
                      validator: (value) => value!=null && value.isNotEmpty?null:'Required field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Drashti Malavia',
                        label: Text('name'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: widget.usermodelClass.about,
                      onSaved: (newValue) => widget.usermodelClass.about=newValue ?? '',
                      validator: (value) => value!=null && value.isNotEmpty?null:'Required field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Feeling happy',
                        label: Text('name'),
                      ),
                    ),
                  ),
                  SizedBox(height: 150,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.green,
                      minimumSize: Size(150, 50),
                    ),
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        updateDataIntoFireBase().then((value) {
                          Dialogs.showSneckBar(context, 'Profile updated successfully !!');
                        },);
                      }
                    },
                    label: Text('UPDATE',style: TextStyle(fontSize: 16,color: Colors.black),),
                    icon: Icon(Icons.edit,color: Colors.black,),
                   ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                },);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                },));
                setState(() {

                });
              },
              backgroundColor: Colors.redAccent.shade200,
              label: Text('Logout',style: TextStyle(color: Colors.white),),
              icon: Icon(Icons.logout,color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateDataIntoFireBase() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.usermodelClass.id).update({'name':'${widget.usermodelClass.name}','about':'${widget.usermodelClass.about}'});
  }
}
