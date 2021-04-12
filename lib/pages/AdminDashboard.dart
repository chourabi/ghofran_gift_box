import 'package:flutter/material.dart';
import 'package:giftbox/pages/admin/AddProductPage.dart';
import 'package:giftbox/pages/admin/commandesPage.dart';
import 'package:giftbox/pages/admin/productsPage.dart';

class AdminDashbard extends StatefulWidget {
  AdminDashbard({Key key}) : super(key: key);

  @override
  _AdminDashbardState createState() => _AdminDashbardState();
}

class _AdminDashbardState extends State<AdminDashbard> {


  List<Widget>  _tabs = new List();
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabs.add(CommandePage());
    _tabs.add(ProductsPage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _tabs.elementAt(_index)
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i){
          setState(() {
            _index = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Commandes')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Produits')
          ),
          

        ],
      ),
      floatingActionButton: _index == 1 ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
      ) : null,
    );
  }
}