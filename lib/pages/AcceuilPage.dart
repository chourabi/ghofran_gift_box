import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/ProductDetails.dart';
import 'package:giftbox/pages/ProduitCategory.dart';
import 'package:giftbox/pages/SignInPage.dart';

class AcceuilPage extends StatefulWidget {
  AcceuilPage({Key key}) : super(key: key);

  @override
  _AcceuilPageState createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {

    List<QueryDocumentSnapshot> _highlitedProducts = new List();
    List<QueryDocumentSnapshot> _subCategorys = new List();
    List<Widget> _subCategorysBloc = new List();




  _getProductFromDatabase(){
    setState(() {
      //_isLoading = true;
    });
    CollectionReference prodRef = FirebaseFirestore.instance.collection('produit'); 

    prodRef.where('highlighted', isEqualTo: true).get().then((res){
      setState(() {
         _highlitedProducts = res.docs;
      });





    });
  }


  _getFirstSubCategories(){
    CollectionReference categorysRef = FirebaseFirestore.instance.collection('subcategorys'); 
    categorysRef.where('first', isEqualTo: true ).get().then((res){
      setState(() {
        _subCategorys = res.docs;
      });



    });

  }

  _addToFav(String idProd){
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      // auth
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage() ),
      );
    }else{
      // add
      print(auth.currentUser);

    CollectionReference favorissRef = FirebaseFirestore.instance.collection('favoris'); 
      favorissRef.where('idClient', isEqualTo: auth.currentUser.uid).where('idProduit', isEqualTo: idProd).get().then((res) {
        if( res.docs.length == 0 ){
          favorissRef.add( {
                "idClient":auth.currentUser.uid,
                "idProduit":idProd
              });
              
        }else{
          // alert error alreay exist ...
        }
      });

    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getProductFromDatabase();
    _getFirstSubCategories();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    print(_subCategorysBloc);


    return (
      SingleChildScrollView(
        child: Container(
        child: Column(children: [
            Container(
              
              width: width,
              height: 150,
                child: Image.asset(
                  'assets/logo.png',
                  width: 190,
                ),
              ),



              Container(
                width: width,
                child: Column(
                  children: new List.generate(_subCategorys.length, (index) {
                    
                    return new GestureDetector(
                      onTap: (){
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProduitCategory(id:_subCategorys[index].id)),
                        );
                      },
                      child: new Container(
            height: 250,
            width: width - 30,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(_subCategorys[index].data()["photoURL"]))
          ),
        ) ,

                    );
                     
        
        
         } ).toList(),







                ) ,
              ),


              Container(
                height: 530,
                width: width,
                child: ListView.builder( 
                  scrollDirection: Axis.horizontal,
                  itemCount: _highlitedProducts.length, itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      String id = _highlitedProducts[index].id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetails(id:id)),
                        );

                    },
                    child: Container(
                    margin: EdgeInsets.all(15),
                    height: 500,
                    width: width - 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(_highlitedProducts[index]["photoURL"]))
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 25,
                          top: 15,
                          child: 
                        IconButton(
                          icon: Icon(Icons.favorite , size: 50,),
                          onPressed: (){
                              _addToFav(_highlitedProducts[index].id);
                          },
                        ),),
                        Positioned(
                          bottom: 0,
                          child: Opacity(
                            opacity: 0.3,
                            child: Container(
                              padding: EdgeInsets.all(10),
                            width: width - 30,
                            height: 80,
                            color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${_highlitedProducts[index]['prix']} TND", style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),),
                                Text("${_highlitedProducts[index]['titre']}", style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w300),)
                              
                              ],
                            ),
                          ),
                          )
                        )
                      ],
                    ),
                  ),
                  );
                }, ),
              )
          ],),
        ),
      )
     
    );
  }
}