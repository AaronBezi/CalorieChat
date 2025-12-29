// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoggedMealImpl _$$LoggedMealImplFromJson(Map<String, dynamic> json) =>
    _$LoggedMealImpl(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      totalCalories: (json['totalCalories'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => LoggedMealItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LoggedMealImplToJson(_$LoggedMealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'totalCalories': instance.totalCalories,
      'timestamp': instance.timestamp.toIso8601String(),
      'items': instance.items,
    };

_$LoggedMealItemImpl _$$LoggedMealItemImplFromJson(Map<String, dynamic> json) =>
    _$LoggedMealItemImpl(
      foodId: json['foodId'] as String,
      foodDescription: json['foodDescription'] as String,
      portion: json['portion'] as String,
      quantity: (json['quantity'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
    );

Map<String, dynamic> _$$LoggedMealItemImplToJson(
  _$LoggedMealItemImpl instance,
) => <String, dynamic>{
  'foodId': instance.foodId,
  'foodDescription': instance.foodDescription,
  'portion': instance.portion,
  'quantity': instance.quantity,
  'calories': instance.calories,
};
