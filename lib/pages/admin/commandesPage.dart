import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/pages/admin/CommandedProduct.dart';

class CommandePage extends StatefulWidget {
  CommandePage({Key key}) : super(key: key);

  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  List<QueryDocumentSnapshot> _listCommandsDocs = new List();

  _getCommandes() {
    CollectionReference comamandesRef =
        FirebaseFirestore.instance.collection('commandes');

    comamandesRef.get().then((res) {
      print(res.docs.length);
      setState(() {
        _listCommandsDocs = res.docs;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    print("getting");
    _getCommandes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: _listCommandsDocs.length,
        itemBuilder: (context, index) {
          String codeClient = _listCommandsDocs[index].data()['idClient'];
          return Container(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(codeClient)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> client = snapshot.data.data();

                          String id = snapshot.data.id;
                          return new GestureDetector(
                              onTap: () {

                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CommandedProduct(produit:_listCommandsDocs[index].data()['produits'])),
                                  );



                              },
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(client['fullname'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    Text(client['phone']),
                                    Text(client['address']),
                                    Text(client['email']),
                                    
                                    
                                  ],
                                ),
                              ));
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                    Container(height: 20,),
                    Container(

                      child: Column(
                        children: [
                          Text("${_listCommandsDocs[index].data()['produits'].length} Produit(s) à commandé")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
