import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewDetails extends StatelessWidget {

  String title, desc;
  ViewDetails({required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("Title : ", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.blue),),
            Text("${title}", style: TextStyle(fontSize: 18),),
            SizedBox(height: 20,),
            Text("Description : ", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.blue),),
            Text("${desc}", style: TextStyle(fontSize: 18),),
          ],
        ),
      )
    );
  }
}
