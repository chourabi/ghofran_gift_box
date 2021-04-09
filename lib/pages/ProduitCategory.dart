import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/ProductDetails.dart';

class ProduitCategory extends StatefulWidget {
  final String id;
  ProduitCategory({Key key, this.id}) : super(key: key);

  @override
  _ProduitCategoryState createState() => _ProduitCategoryState();
}

class _ProduitCategoryState extends State<ProduitCategory> {
  String _id;
  List<QueryDocumentSnapshot> _produit = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.id;

    _getProductFromDatabaseUsingCategory();

  }


  _getProductFromDatabaseUsingCategory(){
        CollectionReference categorysRef = FirebaseFirestore.instance.collection('produit'); 

    categorysRef.where('category', arrayContains: _id).get().then((res){
      setState(() {
        _produit = res.docs;
      });


    });

  }   


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Resultat de Recherche...', style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: ListView.builder(itemCount: _produit.length, itemBuilder: (context, index) {
          return new 
          
          GestureDetector(
                    onTap: (){
                      String id = _produit[index].id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetails(id:id)),
                        );

                    },


                    child :
          
          
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: (width - 30 ) * 0.3 ,
                  child: Image.network(_produit[index].data()['photoURL'], ),
                ),
                Container(
                  width: (width - 30 ) * 0.7 ,
                  padding: EdgeInsets.only(left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Text("${_produit[index].data()['prix']} TND", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
                                
                    Text("${_produit[index].data()['titre']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),)
                              
                  ],),
                )
              ],
            )
          )
          );
        },) ,
      ),
    );
  }
}