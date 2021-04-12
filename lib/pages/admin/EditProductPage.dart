import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/components/CategoryOptions.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  EditProductPage({Key key, this.id}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  String _id;
  TextEditingController _titre = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _photoURL = new TextEditingController();

  List<QueryDocumentSnapshot> _categorys = new List();

  List _selectedCategories = new List();
  bool _isHighLighted = false;

  addCategory(id){
    setState(() {
      _selectedCategories.add(id);
    });
  }

  _getCategories(){
    CollectionReference categorysRef = FirebaseFirestore.instance.collection('subcategorys'); 

    categorysRef.get().then((res){
      setState(() {
        _categorys = res.docs;

      });


    });

  }

  _getProductDetails(){
     CollectionReference p = FirebaseFirestore.instance.collection('produit');
    p.doc(_id).get().then((res){
      _titre.text = res.data()['titre'];
      _description.text = res.data()['description'];
      _price.text = res.data()['prix'];
      _isHighLighted = res.data()['highlighted'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
    _id = widget.id;
    _getProductDetails();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        
        child: Container(
          padding: EdgeInsets.only(top: 25,left:15,right:15),
          child: Column(
          children: [
            TextField(
              controller: _titre,
              decoration: InputDecoration(
                hintText: "Titre"
              ),
            ),
            Container(height: 15,),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                hintText: "Description"
              ),
            ),
            Container(height: 15,),
            TextField(
              controller: _price,
              decoration: InputDecoration(
                hintText: "Prix"
              ),
            ),
            

            Row(
              children: [
                Checkbox(
                  value: _isHighLighted,
                  onChanged: (v){
                    setState(() {
                      _isHighLighted = v;
                    });
                  },
                ),
                Text('Voir en premier')
              ],
            ),


            Container(
              width: MediaQuery.of(context).size.width,
              
              child: RaisedButton(
                color: Colors.amberAccent,
                onPressed: (){
                  CollectionReference p = FirebaseFirestore.instance.collection('produit'); 
                  p.doc(_id).update({
                    'description':_description.text,
                    'highlighted':_isHighLighted,
                    'prix':_price.text,
                    'titre':_titre.text

                  }).then((value){
                    Navigator.pop(context);
                  });
                  
                },  
                child: Text("MODIFIER"),
              ),
            )
            
          ],  
        ),
        ),
      ),
    );
  }
}