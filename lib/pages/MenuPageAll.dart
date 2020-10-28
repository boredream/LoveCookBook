import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Dish.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';

class MenuPageAll extends StatefulWidget {
  MenuPageAll({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MenuPageAll>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  var _tabList = [
    GlobalConstants.EAT_TYPE_HOME,
    GlobalConstants.EAT_TYPE_OUTSIDE
  ];
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("全部菜单"),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return Column(
      children: [
        AppBar(
            automaticallyImplyLeading: false,
            title: TabBar(controller: _controller, tabs: _getTabs())),
        Expanded(
          child: TabBarView(controller: _controller, children: _getTabPages()),
        ),
      ],
    );
  }

  List<Widget> _getTabs() {
    List<Widget> list = [];
    for (var tab in _tabList) {
      list.add(Tab(text: tab));
    }
    return list;
  }

  List<Widget> _getTabPages() {
    List<Widget> list = [];
    for (var tab in _tabList) {
      list.add(MenuPageList(tab));
    }
    return list;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MenuPageList extends StatefulWidget {
  MenuPageList(this.type, {Key key}) : super(key: key);

  final type;

  @override
  _ListPageState createState() => _ListPageState(type);
}

class _ListPageState extends State<MenuPageList> {
  _ListPageState(this.type);

  final type;

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
    return getBody();
  }

  showLoadingDialog() {
    return _dishList.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return Scaffold(
        body: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: _dishList.length,
            itemBuilder: (context, index) {
              return getRow(index);
            }),
        floatingActionButton: FloatingActionButton(
          heroTag: type,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "menuDetail",
                arguments: {"type": type}).then((value) {});
          },
        ),
      );
    }
  }

  Widget getRow(int index) {
    var dish = _dishList[index];
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      onTap: () {
        Navigator.pushNamed(context, "menuDetail", arguments: dish);
      },
    );
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }
}
