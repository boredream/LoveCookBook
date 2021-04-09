import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Stock.dart';
import 'package:flutter_todo/helper/DataHelper.dart';
import 'package:flutter_todo/pages/BaseDetailEditPageState.dart';

class StockDetailEditPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends BaseDetailEditPageState<Stock, StockDetailEditPage> {
  TextEditingController _titleController;
  TextEditingController _maxPriceController;
  TextEditingController _targetBuyTimesController;
  TextEditingController _defBuyCountController;
  TextEditingController _buyGapDaysController;
  TextEditingController _buyGapPriceController;

  String getTitle() {
    return "股票详情";
  }

  String getDataCollectionName() {
    return DataHelper.COLLECTION_STOCK;
  }

  void initData() {
    if (data == null) {
      data = Stock();
      data.items = [];
    }

    _titleController = TextEditingController();
    _maxPriceController = TextEditingController();
    _targetBuyTimesController = TextEditingController();
    _defBuyCountController = TextEditingController();
    _buyGapDaysController = TextEditingController();
    _buyGapPriceController = TextEditingController();

    if (data.name != null) _titleController.text = data.name;
    if (data.maxPrice != null) _maxPriceController.text = data.maxPrice.toString();
    if (data.targetBuyTimes != null) _targetBuyTimesController.text = data.targetBuyTimes.toString();
    if (data.defBuyCount != null) _defBuyCountController.text = data.defBuyCount.toString();
    if (data.buyGapDays != null) _buyGapDaysController.text = data.buyGapDays.toString();
    if (data.buyGapPricePercent != null) _buyGapPriceController.text = data.buyGapPricePercent.toString();
  }

  List<Widget> getFormWidgetList() {
    return [
      TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: "股票名称",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.name = newValue;
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _maxPriceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: "价格上限",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.maxPrice = double.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _targetBuyTimesController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "目标买入总次数",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.targetBuyTimes = int.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _defBuyCountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "默认买入数量",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.defBuyCount = int.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _buyGapDaysController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "买入间隔周期（天）",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.buyGapDays = int.parse(newValue);
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        controller: _buyGapPriceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "机会价格下跌比例（%）",
        ),
        validator: (value) {
          return value.trim().length > 0 ? null : "不能为空";
        },
        onSaved: (newValue) {
          data.buyGapPricePercent = int.parse(newValue);
        },
      ),
    ];
  }
}
