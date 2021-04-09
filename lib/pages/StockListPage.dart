import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Stock.dart';
import 'package:flutter_todo/entity/StockItem.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/pages/BaseListPageState.dart';
import 'package:flutter_todo/views/StockCardView.dart';

import '../main.dart';

class StockListPage extends StatefulWidget {
  StockListPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends BaseListPageState<Stock, StockListPage> {
  @override
  String getTitle() {
    return "股票列表";
  }

  @override
  Future<DbQueryResponse> getLoadDataFuture() {
    return DataHelper.loadData(DataHelper.COLLECTION_STOCK, orderGrow: true);
  }

  @override
  void toEditPage(Stock data) {
    if (data == null) {
      // 新增直接到编辑页
      MyRouteDelegate.of(context).push("stockDetailEdit");
    } else {
      MyRouteDelegate.of(context).push("stockDetail", arguments: {"data": data});
    }
  }

  @override
  List<Stock> setLoadDataResponse(dynamic data) {
    List<Stock> dataList = (data as List).map((e) {
      List<StockItem> items = [];
      if (e['items'] != null) {
        items = (e['items'] as List).map((e) => StockItem.fromJson(new Map<String, dynamic>.from(e))).toList();
        e['items'] = null;
        if (items != null) {
          items.sort((a, b) {
            // 时间倒序
            String aDate = a.date ?? "2100-01-01";
            String bDate = b.date ?? "2100-01-01";
            return bDate.compareTo(aDate);
          });
        }
      }

      Map<String, dynamic> map = new Map<String, dynamic>.from(e);
      Stock data = Stock.fromJson(map);
      data.items = items;
      return data;
    }).toList();
    return dataList;
  }

  @override
  Widget getRow(int index) {
    Stock data = dataList[index];
    return StockCardView(data, () => toEditPage(data));
  }
}
