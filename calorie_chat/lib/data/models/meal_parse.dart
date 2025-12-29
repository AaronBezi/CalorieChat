import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_parse.freezed.dart';
part 'meal_parse.g.dart';

@freezed
class MealParseResponse with _$MealParseResponse {
  const factory MealParseResponse({
    required List<ParsedItem> items,
  }) = _MealParseResponse;

  factory MealParseResponse.fromJson(Map<String, dynamic> json) =>
      _$MealParseResponseFromJson(json);
}

@freezed
class ParsedItem with _$ParsedItem {
  const factory ParsedItem({
    required String query,
    required int quantity,
    String? portionHint,
  }) = _ParsedItem;

  factory ParsedItem.fromJson(Map<String, dynamic> json) =>
      _$ParsedItemFromJson(json);
}
