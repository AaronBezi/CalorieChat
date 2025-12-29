// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_parse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MealParseResponse _$MealParseResponseFromJson(Map<String, dynamic> json) {
  return _MealParseResponse.fromJson(json);
}

/// @nodoc
mixin _$MealParseResponse {
  List<ParsedItem> get items => throw _privateConstructorUsedError;

  /// Serializes this MealParseResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealParseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealParseResponseCopyWith<MealParseResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealParseResponseCopyWith<$Res> {
  factory $MealParseResponseCopyWith(
    MealParseResponse value,
    $Res Function(MealParseResponse) then,
  ) = _$MealParseResponseCopyWithImpl<$Res, MealParseResponse>;
  @useResult
  $Res call({List<ParsedItem> items});
}

/// @nodoc
class _$MealParseResponseCopyWithImpl<$Res, $Val extends MealParseResponse>
    implements $MealParseResponseCopyWith<$Res> {
  _$MealParseResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealParseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ParsedItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealParseResponseImplCopyWith<$Res>
    implements $MealParseResponseCopyWith<$Res> {
  factory _$$MealParseResponseImplCopyWith(
    _$MealParseResponseImpl value,
    $Res Function(_$MealParseResponseImpl) then,
  ) = __$$MealParseResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ParsedItem> items});
}

/// @nodoc
class __$$MealParseResponseImplCopyWithImpl<$Res>
    extends _$MealParseResponseCopyWithImpl<$Res, _$MealParseResponseImpl>
    implements _$$MealParseResponseImplCopyWith<$Res> {
  __$$MealParseResponseImplCopyWithImpl(
    _$MealParseResponseImpl _value,
    $Res Function(_$MealParseResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealParseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$MealParseResponseImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ParsedItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealParseResponseImpl implements _MealParseResponse {
  const _$MealParseResponseImpl({required final List<ParsedItem> items})
    : _items = items;

  factory _$MealParseResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealParseResponseImplFromJson(json);

  final List<ParsedItem> _items;
  @override
  List<ParsedItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'MealParseResponse(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealParseResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of MealParseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealParseResponseImplCopyWith<_$MealParseResponseImpl> get copyWith =>
      __$$MealParseResponseImplCopyWithImpl<_$MealParseResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MealParseResponseImplToJson(this);
  }
}

abstract class _MealParseResponse implements MealParseResponse {
  const factory _MealParseResponse({required final List<ParsedItem> items}) =
      _$MealParseResponseImpl;

  factory _MealParseResponse.fromJson(Map<String, dynamic> json) =
      _$MealParseResponseImpl.fromJson;

  @override
  List<ParsedItem> get items;

  /// Create a copy of MealParseResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealParseResponseImplCopyWith<_$MealParseResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParsedItem _$ParsedItemFromJson(Map<String, dynamic> json) {
  return _ParsedItem.fromJson(json);
}

/// @nodoc
mixin _$ParsedItem {
  String get query => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get portionHint => throw _privateConstructorUsedError;

  /// Serializes this ParsedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParsedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParsedItemCopyWith<ParsedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParsedItemCopyWith<$Res> {
  factory $ParsedItemCopyWith(
    ParsedItem value,
    $Res Function(ParsedItem) then,
  ) = _$ParsedItemCopyWithImpl<$Res, ParsedItem>;
  @useResult
  $Res call({String query, int quantity, String? portionHint});
}

/// @nodoc
class _$ParsedItemCopyWithImpl<$Res, $Val extends ParsedItem>
    implements $ParsedItemCopyWith<$Res> {
  _$ParsedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParsedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? quantity = null,
    Object? portionHint = freezed,
  }) {
    return _then(
      _value.copyWith(
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            portionHint: freezed == portionHint
                ? _value.portionHint
                : portionHint // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParsedItemImplCopyWith<$Res>
    implements $ParsedItemCopyWith<$Res> {
  factory _$$ParsedItemImplCopyWith(
    _$ParsedItemImpl value,
    $Res Function(_$ParsedItemImpl) then,
  ) = __$$ParsedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String query, int quantity, String? portionHint});
}

/// @nodoc
class __$$ParsedItemImplCopyWithImpl<$Res>
    extends _$ParsedItemCopyWithImpl<$Res, _$ParsedItemImpl>
    implements _$$ParsedItemImplCopyWith<$Res> {
  __$$ParsedItemImplCopyWithImpl(
    _$ParsedItemImpl _value,
    $Res Function(_$ParsedItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParsedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? quantity = null,
    Object? portionHint = freezed,
  }) {
    return _then(
      _$ParsedItemImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        portionHint: freezed == portionHint
            ? _value.portionHint
            : portionHint // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParsedItemImpl implements _ParsedItem {
  const _$ParsedItemImpl({
    required this.query,
    required this.quantity,
    this.portionHint,
  });

  factory _$ParsedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParsedItemImplFromJson(json);

  @override
  final String query;
  @override
  final int quantity;
  @override
  final String? portionHint;

  @override
  String toString() {
    return 'ParsedItem(query: $query, quantity: $quantity, portionHint: $portionHint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsedItemImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.portionHint, portionHint) ||
                other.portionHint == portionHint));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, query, quantity, portionHint);

  /// Create a copy of ParsedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsedItemImplCopyWith<_$ParsedItemImpl> get copyWith =>
      __$$ParsedItemImplCopyWithImpl<_$ParsedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParsedItemImplToJson(this);
  }
}

abstract class _ParsedItem implements ParsedItem {
  const factory _ParsedItem({
    required final String query,
    required final int quantity,
    final String? portionHint,
  }) = _$ParsedItemImpl;

  factory _ParsedItem.fromJson(Map<String, dynamic> json) =
      _$ParsedItemImpl.fromJson;

  @override
  String get query;
  @override
  int get quantity;
  @override
  String? get portionHint;

  /// Create a copy of ParsedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParsedItemImplCopyWith<_$ParsedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
