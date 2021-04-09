import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todo/entity/Stock.dart';
import 'package:flutter_todo/entity/StockItem.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/views/StockCardView.dart';

import 'BaseDetailPageState.dart';

class StockDetailPage extends StatefulWidget {
  StockDetailPage({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends BaseDetailPageState<Stock, StockItem, StockDetailPage> {
  @override
  String getTitle() {
    return "股票详情";
  }

  void toEditPage() {
    MyRouteDelegate.of(context).push("stockDetailEdit", arguments: {"data": data});
  }

  void toEditItemPage(StockItem item) {
    MyRouteDelegate.of(context).push("stockItem", arguments: {"data": data, "item": item});
  }

  @override
  Widget buildInfoCard() {
    return StockCardView(data, () => toEditPage());
  }

  @override
  Widget buildRow(int index) {
    StockItem item = data.items[index];
    String info = "[${item.date}] ${item.price} x ${item.count}";
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(info),
            Text(item.getAmount().toStringAsFixed(2)),
          ],
        ),
      ),
      onTap: () => toEditItemPage(item),
    );
  }
}
