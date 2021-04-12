import 'package:flutter/material.dart';

class CommandedProduct extends StatefulWidget {
  final dynamic produit;
  CommandedProduct({Key key, this.produit}) : super(key: key);

  @override
  _CommandedProductState createState() => _CommandedProductState();
}

class _CommandedProductState extends State<CommandedProduct> {

  dynamic _produit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _produit = widget.produit;


    print(_produit);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.builder(itemCount: _produit.length, itemBuilder: (context, index) {
        return  Container(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: (width - 30 ) * 0.3 ,
                  child: Image.network(_produit[index]['details']['details']['photoURL'], ),
                ),
                Container(
                  width: (width - 30 ) * 0.7 ,
                  padding: EdgeInsets.only(left:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Text("${_produit[index]['details']['details']['prix']} TND", style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
                                
                    Text("${_produit[index]['details']['details']['titre']} x ${_produit[index]['details']['count']} ", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w300),)
                              
                  ],),
                )
              ],
            )
          );
      },)
    );
  }
}