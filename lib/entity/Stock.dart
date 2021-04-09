import 'package:flutter_todo/entity/BaseItemBean.dart';
import 'package:flutter_todo/entity/StockItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Stock.g.dart';

// flutter packages pub run build_runner build
@JsonSerializable()
class Stock extends BaseItemBean<StockItem> {
  Stock();

  String name;
  double maxPrice;
  int targetBuyTimes;
  int buyGapDays;
  int buyGapPricePercent;
  int defBuyCount;
  List<StockItem> items;

  @override
  List<StockItem> getItems() {
    return items;
  }

  double getTotalAmount() {
    double totalAmount = 0;
    for (StockItem item in items ?? []) {
      totalAmount += item.getAmount();
    }
    return totalAmount;
  }

  StockItem getNewestItem() {
    if (items == null || items.length == 0) return null;
    return items[0];
  }

  double getTotalCost() {
    int totalCount = 0;
    for (StockItem item in items ?? []) {
      totalCount += item.count;
    }
    return totalCount == 0 ? null : getTotalAmount() / totalCount;
  }

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);

  Map<String, dynamic> toJson() => _$StockToJson(this);
}
