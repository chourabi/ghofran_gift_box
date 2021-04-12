import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giftbox/components/MenuCategory.dart';
import 'package:giftbox/pages/AcceuilPage.dart';
import 'package:giftbox/pages/AdminDashboard.dart';
import 'package:giftbox/pages/CartPage.dart';
import 'package:giftbox/pages/FavorisPage.dart';
import 'package:giftbox/pages/ProduitCategory.dart';
import 'package:giftbox/pages/SearchPage.dart';
import 'package:giftbox/pages/SignInPage.dart';
import 'package:giftbox/pages/profilePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<QueryDocumentSnapshot> _categorys = new List();


  List<Widget> _tabs = new List();
  
  
  bool _isLoading = false;
  int _bottomNavigationIndex = 0;


  _getCategories(){
    CollectionReference categorysRef = FirebaseFirestore.instance.collection('categorys'); 

    categorysRef.get().then((res){
      setState(() {
        _categorys = res.docs;
      });


    });

  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();



    _tabs.add(AcceuilPage());
    _tabs.add(SearchPage());
    _tabs.add(FavorisPage());
    _tabs.add(CartPage());
    _tabs.add(ProfilePage());
    
    
    
    
  }



  _updateProductsUI(String id){
    print(id);
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProduitCategory(id:id)),
    );
  }




  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _bottomNavigationIndex = index;
          });
        },
        selectedItemColor: Colors.red.shade400,
        currentIndex: _bottomNavigationIndex,
        items: [
          BottomNavigationBarItem(
            
          icon: Icon(Icons.home, color: Colors.black,),
          title: Text("Acceuil")
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.black,),
          title: Text("Recherch")
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.black,),
          title: Text("Favoris")
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.black,),
          title: Text("Panier")
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black,),
          title: Text("Profile")
          ),
          
          
          
      ],),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top:25),
              child: Container(
                padding: EdgeInsets.all(15),
                height: 100,
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Container(
              child: ListTile(
                onTap: (){
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminDashbard()),
                        );
                },
                title: Text("Administration"),
              ),
            ),
            Container(
              height: (height - (25 + 100 )),
              child: ListView.builder(
                itemCount: _categorys.length,
                itemBuilder: (context, index) {
                  return  MenuCategory(title: _categorys[index].data()['title'] ,subCategorys: _categorys[index].data()['subs'], update : _updateProductsUI );
                },
               
               
              ),
            )
        ],),
        ),
        )
      ),
      
      body: _isLoading ? 
      Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Image.asset('assets/logo.png'),
            )
            
          ],
        ),
      ):


      


      _tabs.elementAt(_bottomNavigationIndex)
    );
  }
}