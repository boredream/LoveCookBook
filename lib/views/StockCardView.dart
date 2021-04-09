import 'package:flutter/material.dart';
import 'package:flutter_todo/entity/Stock.dart';
import 'package:flutter_todo/entity/StockItem.dart';
import 'package:flutter_todo/utils/DateStrUtils.dart';

class StockCardView extends StatelessWidget {
  final Stock data;
  final Function onClick;

  StockCardView(this.data, this.onClick, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAmount = data.getTotalAmount();
    String totalAmountStr = totalAmount.toStringAsFixed(2);
    int buyTimes = data.items == null ? 0 : data.items.length;
    String buyTimeInfo = "$buyTimes/${data.targetBuyTimes}";
    String costStr = data.getTotalCost() == null ? "[未购买]" : data.getTotalCost().toStringAsFixed(2);
    String maxPriceStr = data.maxPrice.toString();

    StockItem newestItem = data.getNewestItem();
    String newestPriceStr = "[未购买]";
    String nextPriceStr = "[未购买]";
    String newestBuyDateStr = "[未购买]";
    String nextBuyDateStr = "[未购买]";
    if (newestItem != null) {
      double newestPrice = newestItem.price;
      int buyGapPricePercent = data.buyGapPricePercent ?? 5;
      double nextPrice = newestPrice - (newestPrice * buyGapPricePercent / 100);
      newestPriceStr = newestPrice.toString();
      nextPriceStr = "${nextPrice.toStringAsFixed(2)} [-$buyGapPricePercent%]";

      newestBuyDateStr = newestItem.date.substring(2);
      DateTime newestBuyDate = DateStrUtils.str2date(newestBuyDateStr);
      DateTime nextBuyDate = newestBuyDate.add(Duration(days: data.buyGapDays ?? 14));
      nextBuyDateStr = DateStrUtils.date2str(nextBuyDate).substring(2);
    }

    return ListTile(
      title: Text(data.name),
      dense: true,
      subtitle: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("持有总额：$totalAmountStr")),
              Expanded(child: Text("买入次数：$buyTimeInfo")),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("持有成本：$costStr")),
              Expanded(child: Text("价格上限：$maxPriceStr")),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("最新买价：$newestPriceStr")),
              Expanded(child: Text("机会价格：$nextPriceStr")),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("最新日期：$newestBuyDateStr")),
              Expanded(child: Text("下次日期：$nextBuyDateStr")),
            ],
          ),
        ],
      ),
      onTap: onClick,
    );
  }
}
