import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/SignInPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child:
        Column(children: [

          FlatButton(
            onPressed: (){
              FirebaseAuth auth = FirebaseAuth.instance;

              auth.signOut().then((value){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
              });
            },
            child: Text("SIGN OUT"),
          )
        ],)
      ),
    );
  }
}