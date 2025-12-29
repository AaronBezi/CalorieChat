import 'package:freezed_annotation/freezed_annotation.dart';

part 'logged_meal.freezed.dart';
part 'logged_meal.g.dart';

@freezed
class LoggedMeal with _$LoggedMeal {
  const factory LoggedMeal({
    required int id,
    required String description,
    required int totalCalories,
    required DateTime timestamp,
    required List<LoggedMealItem> items,
  }) = _LoggedMeal;

  factory LoggedMeal.fromJson(Map<String, dynamic> json) =>
      _$LoggedMealFromJson(json);
}

@freezed
class LoggedMealItem with _$LoggedMealItem {
  const factory LoggedMealItem({
    required String foodId,
    required String foodDescription,
    required String portion,
    required int quantity,
    required int calories,
  }) = _LoggedMealItem;

  factory LoggedMealItem.fromJson(Map<String, dynamic> json) =>
      _$LoggedMealItemFromJson(json);
}
