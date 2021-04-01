import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/components/MenuCategory.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<QueryDocumentSnapshot> _categorys = new List();


  _getCategories(){
    CollectionReference categorysRef = FirebaseFirestore.instance.collection('categorys'); 

    categorysRef.get().then((res){
      setState(() {
        _categorys = res.docs;
      });


    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
  }



  _updateProductsUI(String id){
    print(id);
  }


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
              child: ListView.builder(
                itemCount: _categorys.length,
                itemBuilder: (context, index) {
                  return  MenuCategory(title: _categorys[index].data()['title'] ,subCategorys: _categorys[index].data()['subs'], update : _updateProductsUI );
                },
               
               
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