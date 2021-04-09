import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/ProductDetails.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

    List<QueryDocumentSnapshot> _favsDocs = new List();



  _getFavorisProducts(){
        FirebaseAuth auth = FirebaseAuth.instance;

    CollectionReference favorissRef = FirebaseFirestore.instance.collection('panier'); 
        favorissRef.where('idClient', isEqualTo: auth.currentUser.uid).get().then((res) {
          setState(() {
            _favsDocs = res.docs;
          });

          
        
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFavorisProducts();
  }






  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        child: ListView.builder( itemCount: _favsDocs.length, itemBuilder: (context, index) {

          
          return FutureBuilder<DocumentSnapshot>(
          future:  FirebaseFirestore.instance.collection('produit').doc(_favsDocs[index].data()['idProd']).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> _produit = snapshot.data.data();


              print('${snapshot.data.exists} hello');


              String id =  snapshot.data.id;
              return new GestureDetector(
                    onTap: (){
                      

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
                  child: Image.network(_produit['photoURL'], ),
                ),
                Container(
                  width: (width - 30 ) * 0.7 ,
                  padding: EdgeInsets.only(left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Text("${_produit['prix']} TND", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
                                
                    Text("${_produit['titre']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),),

                    Container(
                      child: ListTile(
                        title: Text("${_favsDocs[index].data()['count']} Unité", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
                        trailing: IconButton(
                          onPressed: (){
                                CollectionReference favorissRef = FirebaseFirestore.instance.collection('panier'); 
                                    favorissRef.doc(_favsDocs[index].id).delete().then((res) {
                                      _getFavorisProducts();
                                });
                          },
                          icon: Icon(Icons.delete,color: Colors.redAccent,),
                          ),
                      ),
                    )
                              
                  ],),
                )
              ],
            )
          )
          );
            }

            return CircularProgressIndicator();
          },
        );
        
        }, ),
      ),
    );
  }
}