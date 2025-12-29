// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_parse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealParseResponseImpl _$$MealParseResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MealParseResponseImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => ParsedItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MealParseResponseImplToJson(
  _$MealParseResponseImpl instance,
) => <String, dynamic>{'items': instance.items};

_$ParsedItemImpl _$$ParsedItemImplFromJson(Map<String, dynamic> json) =>
    _$ParsedItemImpl(
      query: json['query'] as String,
      quantity: (json['quantity'] as num).toInt(),
      portionHint: json['portionHint'] as String?,
    );

Map<String, dynamic> _$$ParsedItemImplToJson(_$ParsedItemImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'quantity': instance.quantity,
      'portionHint': instance.portionHint,
    };
