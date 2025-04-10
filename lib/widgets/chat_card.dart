
import 'package:chatapp/modelclass/UsermodelClass.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final UsermodelClass usermodelClass;
  ChatCard({required this.usermodelClass,super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        margin: EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        elevation: 0.5,
        child: ListTile(
          title: Text('${widget.usermodelClass.name}'),
          subtitle: Text('${widget.usermodelClass.about}'),
          leading: ClipOval(
            child: Image.network('${widget.usermodelClass.image}',fit: BoxFit.cover,),
          ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ),
      ),
    );
  }
}
