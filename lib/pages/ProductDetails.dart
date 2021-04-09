import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  ProductDetails({Key key, this.id}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  String _idDoc;
  DocumentSnapshot _res;
  int _count = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idDoc = widget.id; 

    _getProductDetails();
  }


  _addToCart(){
            FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference prodRef = FirebaseFirestore.instance.collection('panier'); 

    prodRef.add({
      "idProd":_idDoc,
      "idClient":auth.currentUser.uid,
      "count":_count
    }).then((res){
      
    });
  }


  _getProductDetails(){
    CollectionReference prodRef = FirebaseFirestore.instance.collection('produit'); 

    prodRef.doc(_idDoc).get().then((res){
      setState(() {
        _res = res;
      });
    });
  }


  _updateCount(bool increment){
    if (increment ){
      setState(() {
        _count = (_count+1);
      });
    }else{
      if(_count != 1 ){
        setState(() {
        _count = (_count-1);
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;




    return Scaffold(
      body: _res == null ? Center(child: CircularProgressIndicator(),) 
      
      
      :
      
      SingleChildScrollView(
        child:  

        Container(
          child: Column(children: [
            Image.network(_res.data()['photoURL']),
            Container(
              margin: EdgeInsets.only(left: 15,right: 15,top: 15, bottom: 20),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${_res.data()['prix']} TND", style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),),
                  Text("${_res.data()['titre']}", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.w400),),
                  Container(height: 25,),
                  Text("${_res.data()['description']}", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),),

                  Container(
                    height: 50,
                    width: width - 30 ,

                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _updateCount(false);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.red,
                            child: Center(
                              child: Icon(Icons.exposure_neg_1,color: Colors.white,),
                            ),
                          ),
                        ),
                        Container(
                          width: ( width - (30 + 40 + 40) ),
                          child: Text(' $_count ', textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        GestureDetector(
                          onTap: (){
                            _updateCount(true);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.red,
                            child: Center(
                              child: Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                        ),

                    ],),
                  ),

                  Container(
                    width: width,
                    child: FlatButton(
                      
                      color: Colors.red.shade400,
                      onPressed: () {
                        _addToCart();
                      },
                      child: Text("AJOUTER AU PANIER", style: TextStyle(color: Colors.white),),
                    ),
                  )

                ],
              ),
            )
          ],),
        )
      ),
    );
  }
}