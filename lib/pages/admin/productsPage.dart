import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/admin/EditProductPage.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  List<QueryDocumentSnapshot> _products = new List();


  _getAllProducts(){
    CollectionReference comamandesRef =
        FirebaseFirestore.instance.collection('produit');

    comamandesRef.get().then((res) {
      print(res.docs.length);
      setState(() {
        _products = res.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: ListView.builder(itemCount: _products.length, itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProductPage(id: _products[index].id,)),
                    );
                  },
                  child: Container(
                  width: (width - 30 ) * 0.3 ,
                  child: Image.network( _products[index].data()['photoURL'] ),
                ),
                ),
                Container(
                  width: (width - 30 ) * 0.6 ,
                  padding: EdgeInsets.only(left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Text("${_products[index].data()['prix']} TND", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
                                
                    Text("${_products[index].data()['titre']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),)
                              
                  ],),
                ),
                 Container(
                  width: (width - 30 ) * 0.1 ,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                          CollectionReference p = FirebaseFirestore.instance.collection('produit');
                          p.doc(_products[index].id).delete().then((v){
                            print("deleted !");
                            _getAllProducts();
                          }).catchError((err){
                            print("oups");
                          });

                    },
                  ),
                ),
              ],
            )
          );
      },),
    );
  }
}