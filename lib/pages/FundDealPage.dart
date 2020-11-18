import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class FundDealPage extends StatefulWidget {
  FundDealPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<FundDealPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    return widgets.length == 0;
  }

  getBody() {
//    if (showLoadingDialog()) {
//      return getProgressDialog();
//    } else {
//      return getListView();
//    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          FlatButton(
              padding: EdgeInsets.all(20),
              child: Text("已有菜单"),
              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) {
//                      return DishPage();
//                    }));
                Navigator.pushNamed(context, "dish");
              }),
          FlatButton(
            padding: EdgeInsets.all(20),
            child: Text("新菜研究"),
            onPressed: () {},
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Widget getRow(int i) {
    return Container(
      height: 80,
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
            child: Text("Row ${widgets[i]["title"]}"),
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Future<void> loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
