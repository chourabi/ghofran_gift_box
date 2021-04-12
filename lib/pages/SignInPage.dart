import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/AdminDashboard.dart';
import 'package:giftbox/pages/HomePage.dart';

class SignInPage extends StatefulWidget {



  SignInPage({Key key}) : super(key: key);


  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

TextEditingController _emailControl = new TextEditingController();
TextEditingController _passwordControl = new TextEditingController();

  bool _isLoading = false;
  String _errMessage ="";

  FirebaseAuth auth = FirebaseAuth.instance;


  _signinAccount(String email, String password){

    setState(() {
      _isLoading = ! _isLoading;
      _errMessage="";
    });
    auth.signInWithEmailAndPassword(email: email, password: password).then(( response){
      setState(() {
        _isLoading = ! _isLoading;
      });

      print(response);

      if ( response.user.uid == "Fk1NDlItlANtyIvzZDmsieAw69f1" ) {
        // redirect to admin dashboard 
        
          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashbard()),
                    );

      } else {
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
      
      }
         
    }).catchError((e){


      setState(() {
        _isLoading = ! _isLoading;
        _errMessage = e.message;
      });
      
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        title: Text('SIGN IN '),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  errorText:  null
                ),
                controller: _emailControl,

              ),
            ),
            Container(
              
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: _passwordControl,
                obscureText: true,

              ),
            ),

            _isLoading == false ?

            RaisedButton(
              onPressed: (){
                // create account firebase


                _signinAccount(_emailControl.text, _passwordControl.text);



              },
              child: Text('CONNECT'),
            ):

            CircularProgressIndicator(),


            _errMessage == "" ? Container() : 

            Container(
              margin: EdgeInsets.all(15
              ),
              padding: EdgeInsets.all(20),
              color: Colors.red.shade700,
              child: Text(_errMessage, style: TextStyle(color: Colors.white),),
            )
            
          ],
        ),
      ),
      
     
    );
  }
}