import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/database.dart';
import 'package:todo/widgets/add_data.dart';
import 'package:todo/widgets/uihelper.dart';
import 'package:todo/widgets/viewdetails.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  //function to read the user details from Firebase Firestore
  Stream? UserStream;
  getontheload() async{
    UserStream = await DatabaseMethod().getUserInfo();
    setState(() {

    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }


  Widget allUserDetails() {
    return StreamBuilder(stream: UserStream, builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData?
      ListView.builder(itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ds = snapshot.data.docs[index];
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(

                        child: Text("Title : "+ds["title"],
                          style: TextStyle(color: Colors.blue, fontSize: 20,fontWeight: FontWeight.bold, ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      //View the details
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetails(title: ds["title"].toString(), desc: ds["desc"].toString(),)));
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.blue,),
                      ),
                      SizedBox(width: 10,),
                      //Update the data
                      GestureDetector(
                        onTap: () {
                          titleController.text = ds["title"];
                          descController.text = ds["desc"];
                          EditUserDetails(ds["Id"]);
                        },
                          child: Icon(Icons.edit, color: Colors.lightBlue,)),
                      SizedBox(width: 10,),
                      //Delete the data
                      GestureDetector(
                        onTap: () async{
                          await DatabaseMethod().deleteUserDetails(ds["Id"]);
                        },
                          child: Icon(Icons.delete, color: Colors.lightBlue,)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Decs : " + ds["desc"], style: TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
          ),
        );
      }) : Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddData()));
      },
      child: CircleAvatar(
        radius: 40,
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white,)),),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Expanded(
                child: allUserDetails(),
            ),
          ],
        ),
      ),
    );
  }
  //Function for edit user details
  Future EditUserDetails(String id) => showDialog(context: context, builder: (context) => AlertDialog(
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    content: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Edit Details"),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                }, child: Icon(Icons.cancel),
              ),

            ],
          ),
          SizedBox(height: 20,),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),

              ),
              label: Text("Title"),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),

              ),
              label: Text("Description"),
            ),
            maxLines: 5,

          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () async{
            Map<String, dynamic> updateInfo = {
              "title" : titleController.text,
              "desc" : descController.text,
              "Id" : id,
            };
            await DatabaseMethod().updateUserDetails(id, updateInfo).then((value) {
              Navigator.pop(context);
            });
          }, child: Text("Update")),
        ],
      ),
    ),
  ));
}
