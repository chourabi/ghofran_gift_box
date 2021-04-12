import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/ProductDetails.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query="";
  List<QueryDocumentSnapshot> _searchList = new List();


  _updateSearchList(){
    CollectionReference favorissRef = FirebaseFirestore.instance.collection('produit'); 
      favorissRef.get().then((res) {
        setState(() {
          _searchList = res.docs;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
       child: Container(
         child: Column(
           children: [
             Container(height: 25,),
             Container(
               padding: EdgeInsets.all(15),
               height: 60,
               child: TextField(
                 onChanged: (str){
                   setState(() {
                     _query = str;
                   });

                   _updateSearchList();



                 },
               ),
             ),
             Container(
               height: height-150,
               child: ListView.builder( itemCount: _searchList.length, itemBuilder: (context, index){
                 String productTile = _searchList[index].data()['titre'];
                 String id = _searchList[index].id;
                 if (productTile.toLowerCase().contains(_query.toLowerCase())) {
                   return ListTile(
                     onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetails(id:id)),
                        );
                     },
                   title: Text(" ${_searchList[index].data()['titre']} "),
                 );
                 }
                 return Container();
               }
                 
               )
             )


           ],
         ),
       ),
    )
    );
  }
}