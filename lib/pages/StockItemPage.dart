import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Stock.dart';
import 'package:flutter_todo/entity/StockItem.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/pages/BaseItemPageState.dart';
import 'package:flutter_todo/utils/DateStrUtils.dart';

class StockItemPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends BaseItemPageState<Stock, StockItem, StockItemPage> {
  TextEditingController _priceController;
  TextEditingController _countController;

  @override
  String getTitle() {
    return "股票买入记录";
  }

  String getDataCollectionName() {
    return DataHelper.COLLECTION_STOCK;
  }

  @override
  void initData() {
    if (item == null) {
      item = StockItem();
      item.count = data.defBuyCount;
      item.date = DateStrUtils.date2str(DateTime.now());
    }

    _priceController = TextEditingController();
    _countController = TextEditingController();

    if (item.price != null) _priceController.text = item.price.toString();
    if (item.count != null) _countController.text = item.count.toString();
  }

  List<Widget> getFormWidgetList() {
    return [
      TextFormField(
        controller: _priceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: "买入价格",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          item.price = double.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _countController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "买入数量",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          item.count = int.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "买入时间：",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            Text(
              item.date,
              style: Theme.of(context).primaryTextTheme.bodyText1,
            ),
          ],
        ),
        onTap: () {
          selectData();
        },
      ),
    ];
  }

  selectData() async {
    DateTime initialDate = DateTime.now();
    if (item.date != null) {
      initialDate = DateStrUtils.str2date(item.date);
    }

    DateTime date = await DateStrUtils.showCustomDatePicker(context, initialDate: initialDate);
    setState(() {
      item.date = DateStrUtils.date2str(date);
    });
  }
}
