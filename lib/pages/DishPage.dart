import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Dish.dart';
import 'package:http/http.dart' as http;

class DishPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DishPage> {
  List<Dish> _dishList = [
    Dish("麻辣香锅",
        "https://i3.meishichina.com/attachment/recipe/2017/11/23/20171123151140689618713.jpg?x-oss-process=style/c320"),
    Dish("土豆炒肉丝",
        "http://i2.chuimg.com/8dee037e3e964a00b22d456768732eb3_1920w_1080h.jpg?imageView2/1/w/215/h/136/interlace/1/q/90"),
    Dish("麻辣香锅",
        "https://i3.meishichina.com/attachment/recipe/2017/11/23/20171123151140689618713.jpg?x-oss-process=style/c320"),
    Dish("土豆炒肉丝",
        "http://i2.chuimg.com/8dee037e3e964a00b22d456768732eb3_1920w_1080h.jpg?imageView2/1/w/215/h/136/interlace/1/q/90"),
  ];

  @override
  void initState() {
    super.initState();
//    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已有菜单"),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "dishDetail");
        },
      ),
    );
  }

  showLoadingDialog() {
    return _dishList.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: _dishList.length,
          itemBuilder: (context, index) {
            return getRow(index);
          });
    }
  }

  Widget getRow(int index) {
    var dish = _dishList[index];
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                dish.image,
                fit: BoxFit.cover,
              ),
            ),
            Text(dish.name),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "dishDetail", arguments: dish);
      },
    );
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }
//  Future<void> loadData() async {
//    String dataURL = "https://jsonplaceholder.typicode.com/posts";
//    http.Response response = await http.get(dataURL);
//    setState(() {
//      widgets = json.decode(response.body);
//    });
//  }
}
