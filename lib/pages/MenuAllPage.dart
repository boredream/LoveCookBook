import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Menu.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/helper/GlobalConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuAllPage extends StatefulWidget {
  MenuAllPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MenuAllPage>
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
        title: Text("全部菜品"),
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

  bool _hasLoadData = false;
  List<Menu> _menuList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    var where = {"type": type};
    DataHelper.loadData(DataHelper.COLLECTION_MENU, where).then((value) {
      if (!this.mounted) return;
      if (value.code != null) {
        loadDataError(value.message);
        return;
      }

      setState(() {
        _hasLoadData = true;
        _menuList = (value.data as List)
            .map((e) => Menu.fromJson(new Map<String, dynamic>.from(e)))
            .toList();
      });
    }).catchError(loadDataError);
  }

  loadDataError(error) {
    Fluttertoast.showToast(msg: "加载失败 " + error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    if (_hasLoadData) {
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
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return getRow(index);
            }),
        floatingActionButton: FloatingActionButton(
          heroTag: type,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "menuDetail",
                arguments: {"type": type}).then((value) => loadData());
          },
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget getRow(int index) {
    var menu = _menuList[index];
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              menu.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Text(menu.name),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, "menuDetail",
            arguments: {"type": type, "menu": menu})
            .then((value) => loadData());
      },
    );
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }
}
