import 'package:flutter/material.dart';

class CategoryOptions extends StatefulWidget {
  final String id;
  final dynamic fun;
  final String title;
  
  CategoryOptions({Key key, this.id, this.fun, this.title}) : super(key: key);

  @override
  _CategoryOptionsState createState() => _CategoryOptionsState();
}

class _CategoryOptionsState extends State<CategoryOptions> {
  bool _stateValue = false;
  String _id;
  dynamic _fun;
  String _title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = widget.id;
    _fun = widget.fun;
    _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Row(
              children: [
                Checkbox(
                  tristate: false,
                  value: _stateValue,
                  onChanged: (v){
                    _fun(_id);
                    print(v);
                    setState(() {
                      _stateValue = v;
                    });
                  },

                ),
                Text(_title)
              ],
            )
    );
  }
}