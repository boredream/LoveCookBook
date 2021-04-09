// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) {
  return Stock()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..maxPrice = (json['maxPrice'] as num)?.toDouble()
    ..targetBuyTimes = json['targetBuyTimes'] as int
    ..buyGapDays = json['buyGapDays'] as int
    ..buyGapPricePercent = json['buyGapPricePercent'] as int
    ..defBuyCount = json['defBuyCount'] as int
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : StockItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'maxPrice': instance.maxPrice,
      'targetBuyTimes': instance.targetBuyTimes,
      'buyGapDays': instance.buyGapDays,
      'buyGapPricePercent': instance.buyGapPricePercent,
      'defBuyCount': instance.defBuyCount,
      'items': instance.items,
    };
