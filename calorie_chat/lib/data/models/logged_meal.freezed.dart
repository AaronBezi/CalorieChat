// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logged_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoggedMeal _$LoggedMealFromJson(Map<String, dynamic> json) {
  return _LoggedMeal.fromJson(json);
}

/// @nodoc
mixin _$LoggedMeal {
  int get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<LoggedMealItem> get items => throw _privateConstructorUsedError;

  /// Serializes this LoggedMeal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoggedMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoggedMealCopyWith<LoggedMeal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoggedMealCopyWith<$Res> {
  factory $LoggedMealCopyWith(
    LoggedMeal value,
    $Res Function(LoggedMeal) then,
  ) = _$LoggedMealCopyWithImpl<$Res, LoggedMeal>;
  @useResult
  $Res call({
    int id,
    String description,
    int totalCalories,
    DateTime timestamp,
    List<LoggedMealItem> items,
  });
}

/// @nodoc
class _$LoggedMealCopyWithImpl<$Res, $Val extends LoggedMeal>
    implements $LoggedMealCopyWith<$Res> {
  _$LoggedMealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoggedMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? totalCalories = null,
    Object? timestamp = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCalories: null == totalCalories
                ? _value.totalCalories
                : totalCalories // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<LoggedMealItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoggedMealImplCopyWith<$Res>
    implements $LoggedMealCopyWith<$Res> {
  factory _$$LoggedMealImplCopyWith(
    _$LoggedMealImpl value,
    $Res Function(_$LoggedMealImpl) then,
  ) = __$$LoggedMealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String description,
    int totalCalories,
    DateTime timestamp,
    List<LoggedMealItem> items,
  });
}

/// @nodoc
class __$$LoggedMealImplCopyWithImpl<$Res>
    extends _$LoggedMealCopyWithImpl<$Res, _$LoggedMealImpl>
    implements _$$LoggedMealImplCopyWith<$Res> {
  __$$LoggedMealImplCopyWithImpl(
    _$LoggedMealImpl _value,
    $Res Function(_$LoggedMealImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoggedMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? totalCalories = null,
    Object? timestamp = null,
    Object? items = null,
  }) {
    return _then(
      _$LoggedMealImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCalories: null == totalCalories
            ? _value.totalCalories
            : totalCalories // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<LoggedMealItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoggedMealImpl implements _LoggedMeal {
  const _$LoggedMealImpl({
    required this.id,
    required this.description,
    required this.totalCalories,
    required this.timestamp,
    required final List<LoggedMealItem> items,
  }) : _items = items;

  factory _$LoggedMealImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoggedMealImplFromJson(json);

  @override
  final int id;
  @override
  final String description;
  @override
  final int totalCalories;
  @override
  final DateTime timestamp;
  final List<LoggedMealItem> _items;
  @override
  List<LoggedMealItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'LoggedMeal(id: $id, description: $description, totalCalories: $totalCalories, timestamp: $timestamp, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoggedMealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    description,
    totalCalories,
    timestamp,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of LoggedMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoggedMealImplCopyWith<_$LoggedMealImpl> get copyWith =>
      __$$LoggedMealImplCopyWithImpl<_$LoggedMealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoggedMealImplToJson(this);
  }
}

abstract class _LoggedMeal implements LoggedMeal {
  const factory _LoggedMeal({
    required final int id,
    required final String description,
    required final int totalCalories,
    required final DateTime timestamp,
    required final List<LoggedMealItem> items,
  }) = _$LoggedMealImpl;

  factory _LoggedMeal.fromJson(Map<String, dynamic> json) =
      _$LoggedMealImpl.fromJson;

  @override
  int get id;
  @override
  String get description;
  @override
  int get totalCalories;
  @override
  DateTime get timestamp;
  @override
  List<LoggedMealItem> get items;

  /// Create a copy of LoggedMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoggedMealImplCopyWith<_$LoggedMealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoggedMealItem _$LoggedMealItemFromJson(Map<String, dynamic> json) {
  return _LoggedMealItem.fromJson(json);
}

/// @nodoc
mixin _$LoggedMealItem {
  String get foodId => throw _privateConstructorUsedError;
  String get foodDescription => throw _privateConstructorUsedError;
  String get portion => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;

  /// Serializes this LoggedMealItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoggedMealItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoggedMealItemCopyWith<LoggedMealItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoggedMealItemCopyWith<$Res> {
  factory $LoggedMealItemCopyWith(
    LoggedMealItem value,
    $Res Function(LoggedMealItem) then,
  ) = _$LoggedMealItemCopyWithImpl<$Res, LoggedMealItem>;
  @useResult
  $Res call({
    String foodId,
    String foodDescription,
    String portion,
    int quantity,
    int calories,
  });
}

/// @nodoc
class _$LoggedMealItemCopyWithImpl<$Res, $Val extends LoggedMealItem>
    implements $LoggedMealItemCopyWith<$Res> {
  _$LoggedMealItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoggedMealItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? foodDescription = null,
    Object? portion = null,
    Object? quantity = null,
    Object? calories = null,
  }) {
    return _then(
      _value.copyWith(
            foodId: null == foodId
                ? _value.foodId
                : foodId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodDescription: null == foodDescription
                ? _value.foodDescription
                : foodDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            portion: null == portion
                ? _value.portion
                : portion // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            calories: null == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoggedMealItemImplCopyWith<$Res>
    implements $LoggedMealItemCopyWith<$Res> {
  factory _$$LoggedMealItemImplCopyWith(
    _$LoggedMealItemImpl value,
    $Res Function(_$LoggedMealItemImpl) then,
  ) = __$$LoggedMealItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String foodId,
    String foodDescription,
    String portion,
    int quantity,
    int calories,
  });
}

/// @nodoc
class __$$LoggedMealItemImplCopyWithImpl<$Res>
    extends _$LoggedMealItemCopyWithImpl<$Res, _$LoggedMealItemImpl>
    implements _$$LoggedMealItemImplCopyWith<$Res> {
  __$$LoggedMealItemImplCopyWithImpl(
    _$LoggedMealItemImpl _value,
    $Res Function(_$LoggedMealItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoggedMealItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? foodDescription = null,
    Object? portion = null,
    Object? quantity = null,
    Object? calories = null,
  }) {
    return _then(
      _$LoggedMealItemImpl(
        foodId: null == foodId
            ? _value.foodId
            : foodId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodDescription: null == foodDescription
            ? _value.foodDescription
            : foodDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        portion: null == portion
            ? _value.portion
            : portion // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        calories: null == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoggedMealItemImpl implements _LoggedMealItem {
  const _$LoggedMealItemImpl({
    required this.foodId,
    required this.foodDescription,
    required this.portion,
    required this.quantity,
    required this.calories,
  });

  factory _$LoggedMealItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoggedMealItemImplFromJson(json);

  @override
  final String foodId;
  @override
  final String foodDescription;
  @override
  final String portion;
  @override
  final int quantity;
  @override
  final int calories;

  @override
  String toString() {
    return 'LoggedMealItem(foodId: $foodId, foodDescription: $foodDescription, portion: $portion, quantity: $quantity, calories: $calories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoggedMealItemImpl &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.foodDescription, foodDescription) ||
                other.foodDescription == foodDescription) &&
            (identical(other.portion, portion) || other.portion == portion) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.calories, calories) ||
                other.calories == calories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    foodId,
    foodDescription,
    portion,
    quantity,
    calories,
  );

  /// Create a copy of LoggedMealItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoggedMealItemImplCopyWith<_$LoggedMealItemImpl> get copyWith =>
      __$$LoggedMealItemImplCopyWithImpl<_$LoggedMealItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoggedMealItemImplToJson(this);
  }
}

abstract class _LoggedMealItem implements LoggedMealItem {
  const factory _LoggedMealItem({
    required final String foodId,
    required final String foodDescription,
    required final String portion,
    required final int quantity,
    required final int calories,
  }) = _$LoggedMealItemImpl;

  factory _LoggedMealItem.fromJson(Map<String, dynamic> json) =
      _$LoggedMealItemImpl.fromJson;

  @override
  String get foodId;
  @override
  String get foodDescription;
  @override
  String get portion;
  @override
  int get quantity;
  @override
  int get calories;

  /// Create a copy of LoggedMealItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoggedMealItemImplCopyWith<_$LoggedMealItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
