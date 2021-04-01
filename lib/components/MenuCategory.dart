import 'package:flutter/material.dart';

/*class MenuCategory extends StatelessWidget {
  final String title;
  final int count;
  const MenuCategory({Key key, this.title, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(title,style: TextStyle( color: Color.fromRGBO(207, 6, 14, 1),fontWeight: FontWeight.bold, fontSize: 25 ), )
      ,trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black
        ),
         height: 20, width: 20, child: Center(child: Text('${count}',style: TextStyle(color: Colors.white),),), 
         
         ),
      );
  }
}*/


class MenuCategory extends StatefulWidget {
  final String title;
  final dynamic subCategorys;
  final dynamic update;
  
  const MenuCategory({Key key, this.title, this.subCategorys, this.update}) : super(key: key);

  @override
  _MenuCategoryState createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> with SingleTickerProviderStateMixin {

   dynamic subCategorys;
   bool _isOpned = false;

  AnimationController _animationController;

  Function update;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    update = widget.update;

    subCategorys = widget.subCategorys;

         _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    _animationController.forward();

    
      
  }


  List<Widget> generateSubCategorys(){
      List<Widget> tmp = new List<Widget>();

      for (var i = 0; i < subCategorys.length; i++) {
              Widget subcategory = new Container(
        child: Column(children: [
          Divider(
                    thickness: 1,
                  ),
                  ListTile(title: Text(subCategorys[i]['title'],style: TextStyle( color: Colors.grey.shade500 , fontSize: 20 ),),
                  
                  onTap: (){
                    update(subCategorys[i]['id']);
                  },)
                  
        ],),
      );

      tmp.add(subcategory);
      }


      return tmp;
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [

          ListTile(
            onTap: (){
              setState(() {
                _isOpned = ! _isOpned;

                if (_isOpned) {
                  _animationController.reverse();
                }else{
                  _animationController.forward();
                }
              });
            },
                title: Text(widget.title,style: TextStyle( color: Color.fromRGBO(207, 6, 14, 1),fontWeight: FontWeight.bold, fontSize: 25 ), )
                ,trailing: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black
                  ),
                  height: 20, width: 20, child: Center(child: Text('${subCategorys.length}',style: TextStyle(color: Colors.white),),), 
                  
                  ),
                  leading: AnimatedIcon(icon: AnimatedIcons.close_menu, progress: _animationController, ),
          ),

          AnimatedContainer(
            height: _isOpned == false ? 0 : null,
            duration: Duration(milliseconds: 200),
            child: Column(
              children: generateSubCategorys(),
            ),  
          )
                


        ],
      )
    );
}

}