import 'package:flutter/material.dart';
import 'package:giftbox/components/MenuCategory.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top:25),
              child: Container(
                padding: EdgeInsets.all(15),
                height: 100,
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Container(
              height: (height - (25 + 100 )),
              child: ListView(
                children: [
                 MenuCategory(title: 'CADEAUX VIP',subCategorys: [ { "title":"Chocolat personnalisé", "id":15 },{ "title":"Livres photos", "id":16 }, ]   ,),
                 MenuCategory(title: 'A VIVRE',subCategorys: [ { "title":"Détente & Bien être", "id":0 },{ "title":"Weekend & Séjour", "id":17 }, ]   ,),

                ],
              ),
            )
        ],),
        )
      ),
      
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            
          ],
        ),
      ),
     
    );
  }
}