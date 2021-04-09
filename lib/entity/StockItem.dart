import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'StockItem.g.dart';

// flutter packages pub run build_runner watch
@JsonSerializable()
class StockItem implements Comparable<StockItem> {
  StockItem();

  double price;
  String date;
  int count;

  double getAmount() {
    double amount = price * count;
    double fee = max(amount * 0.0002, 5); // 手续费
    amount += fee;
    return amount;
  }

  factory StockItem.fromJson(Map<String, dynamic> json) => _$StockItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockItemToJson(this);

  @override
  int compareTo(StockItem other) {
    String aDate = date ?? "2100-01-01";
    String bDate = other.date ?? "2100-01-01";
    return bDate.compareTo(aDate);
  }
}
