import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/components/CategoryOptions.dart';

class AddProductPage extends StatefulWidget {
  AddProductPage({Key key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
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
            Container(height: 15,),
            TextField(
              controller: _photoURL,
              decoration: InputDecoration(
                hintText: "Photo ( url )"
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

            Container(height: 15,),
            Container(
              child: Text("Catégories ${_selectedCategories.length} selectionné "),
            ),
            
            Container(
              height: 250,
              child: ListView.builder( itemCount: _categorys.length, itemBuilder: (context, index) {
                return CategoryOptions(id: _categorys[index].id ,fun:addCategory,title: _categorys[index].data()['title'],);
              }, ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              
              child: RaisedButton(
                color: Colors.amberAccent,
                onPressed: (){
                  CollectionReference p = FirebaseFirestore.instance.collection('produit'); 
                  p.add({
                    'category':_selectedCategories,
                    'description':_description.text,
                    'highlighted':_isHighLighted,
                    'photoURL':_photoURL.text,
                    'prix':_price.text,
                    'titre':_titre.text

                  }).then((value){
                    Navigator.pop(context);
                  });
                  
                },  
                child: Text("AJOUTER"),
              ),
            )
            
          ],  
        ),
        ),
      ),
    );
  }
}