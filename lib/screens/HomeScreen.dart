

import 'package:chatapp/screens/ProfileScreen.dart';
import 'package:chatapp/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modelclass/UsermodelClass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cu=FirebaseAuth.instance.currentUser!;
  late UsermodelClass me;
  List list=[];
  final List SearchList=[];
  bool issearch=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(issearch){
            setState(() {
              issearch=false;
            });
            return Future.value(false);
          }
          else{
            return Future.value(true);
          }

        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: issearch?TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                  hintText: 'Name,email...',
                ),
                autofocus: true,
                style: TextStyle(fontSize: 16,letterSpacing: 0.5),
                onChanged: (value) {
                  SearchList.clear();
                  for(var i in list){
                    if(i.name.toLowerCase().contains(value.toLowerCase()) || i.email.toLowerCase().contains(value.toLowerCase())){
                      SearchList.add(i);
                    }
                  }
                  setState(() {

                  });
                },
              ):Text('ChatApp'),
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: Icon(Icons.home_outlined,size: 30,),
              actions: [
                InkWell(
                  onTap: () {
                    issearch=!issearch;
                    setState(() {

                    });
                  },
                  child: Container(
                    child: Icon(issearch?CupertinoIcons.clear_circled_solid:Icons.search,size: 30,),
                  ),
                ),
                SizedBox(width: 20,),
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Profilescreen(usermodelClass: me,);
                      },));
                    });
                  },
                    child: Icon(Icons.more_vert)
                ),
                SizedBox(width: 20,)
              ],
            ),
            body: StreamBuilder(
              stream: getChatId(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data=snapshot.data?.docs;
                    list=data?.map((e)=>UsermodelClass.fromJson(e.data())).toList() ?? [];
                    if(list.isNotEmpty){
                      return ListView.builder(
                        itemCount: issearch?SearchList.length:list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatCard(usermodelClass: issearch?SearchList[index]:list[index],);
                        },
                      );
                    }
                    else{
                      return Center(child: Text('Oops!!!\nNo user Found!!',style: TextStyle(color: Colors.red,fontSize: 32),textAlign: TextAlign.center,));
                    }
                  }
              },
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              onPressed: () {

              },child: Icon(Icons.add),),
          ),
        ),
      ),
    );
  }

  getChatId() {
    return FirebaseFirestore.instance.collection('users').where('id',isNotEqualTo: cu.uid).snapshots();
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

  Future<void> getSelfInfo() async {
    await FirebaseFirestore.instance.collection('users').doc(cu.uid).get().then((value) async {
      if(value.exists){
        me=UsermodelClass.fromJson(value.data()!);
      }
      else{
        await CreateUser().then((value) => getSelfInfo(),);
      }
    },);
  }
}
