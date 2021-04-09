// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StockItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockItem _$StockItemFromJson(Map<String, dynamic> json) {
  return StockItem()
    ..price = (json['price'] as num)?.toDouble()
    ..date = json['date'] as String
    ..count = json['count'] as int;
}

Map<String, dynamic> _$StockItemToJson(StockItem instance) => <String, dynamic>{
      'price': instance.price,
      'date': instance.date,
      'count': instance.count,
    };
