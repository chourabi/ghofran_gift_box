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
    double _total = 0;

    List<dynamic> _produitTotalToBuy = new List();


  _getFavorisProducts(){
        FirebaseAuth auth = FirebaseAuth.instance;

    CollectionReference favorissRef = FirebaseFirestore.instance.collection('panier'); 
        favorissRef.where('idClient', isEqualTo: auth.currentUser.uid).get().then((res) {
          setState(() {
            _favsDocs = res.docs;
          });

          
        
    });

  }


  
  _getTotalPrix(){
    
        FirebaseAuth auth = FirebaseAuth.instance;

          CollectionReference favorissRef = FirebaseFirestore.instance.collection('panier'); 
            favorissRef.where('idClient', isEqualTo: auth.currentUser.uid).get().then((res) {
              
              List<QueryDocumentSnapshot> tmp  = res.docs;

              
              for (var i = 0; i < tmp.length; i++) {
                var count = tmp[i].data()['count'];
                print( "hello test ${tmp[0].data()} "  );
                
                FirebaseFirestore.instance.collection('produit').doc(tmp[i].data()['idProd']).get().then((res){
                  
                  setState(() {
                    _total = _total + ( count * ( double.parse(res.data()['prix']) ) );
                  });
                });
                 
              }
                
              

              
            
        });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFavorisProducts();
    _getTotalPrix();
  }






  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Total : $_total TND', style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              FirebaseAuth auth = FirebaseAuth.instance;

              CollectionReference cmd = FirebaseFirestore.instance.collection('commandes'); 
                  cmd.add({
                    "idClient":auth.currentUser.uid,
                    "produits":_produitTotalToBuy
                  }) .then((res) {
                    
              });
             

            },
          )
        ],
      ),
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

              _produitTotalToBuy.add({
                "details":{
                  "id":snapshot.data.id,
                  "details":_produit,
                  "count": _favsDocs[index].data()['count']
                }
              });


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
      )
    );
  }
}