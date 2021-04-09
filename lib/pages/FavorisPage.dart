import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/ProductDetails.dart';

class FavorisPage extends StatefulWidget {
  FavorisPage({Key key}) : super(key: key);

  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {

    List<QueryDocumentSnapshot> _favsDocs = new List();



  _getFavorisProducts(){
        FirebaseAuth auth = FirebaseAuth.instance;

    CollectionReference favorissRef = FirebaseFirestore.instance.collection('favoris'); 
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
          future:  FirebaseFirestore.instance.collection('produit').doc(_favsDocs[index].data()['idProduit']).get(),
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
                                
                    Text("${_produit['titre']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),)
                              
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