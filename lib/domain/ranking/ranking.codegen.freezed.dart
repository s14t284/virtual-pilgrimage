// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ranking.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Ranking _$RankingFromJson(Map<String, dynamic> json) {
  return _Ranking.fromJson(json);
}

/// @nodoc
mixin _$Ranking {
/**
     * 日次のランキング
     */
  RankingByPeriod get daily => throw _privateConstructorUsedError;
  /**
     * 週次のランキング
     */
  RankingByPeriod get weekly => throw _privateConstructorUsedError;
  /**
     * 月次のランキング
     */
  RankingByPeriod get monthly => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RankingCopyWith<Ranking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingCopyWith<$Res> {
  factory $RankingCopyWith(Ranking value, $Res Function(Ranking) then) =
      _$RankingCopyWithImpl<$Res, Ranking>;
  @useResult
  $Res call(
      {RankingByPeriod daily, RankingByPeriod weekly, RankingByPeriod monthly});

  $RankingByPeriodCopyWith<$Res> get daily;
  $RankingByPeriodCopyWith<$Res> get weekly;
  $RankingByPeriodCopyWith<$Res> get monthly;
}

/// @nodoc
class _$RankingCopyWithImpl<$Res, $Val extends Ranking>
    implements $RankingCopyWith<$Res> {
  _$RankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daily = null,
    Object? weekly = null,
    Object? monthly = null,
  }) {
    return _then(_value.copyWith(
      daily: null == daily
          ? _value.daily
          : daily // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RankingByPeriodCopyWith<$Res> get daily {
    return $RankingByPeriodCopyWith<$Res>(_value.daily, (value) {
      return _then(_value.copyWith(daily: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RankingByPeriodCopyWith<$Res> get weekly {
    return $RankingByPeriodCopyWith<$Res>(_value.weekly, (value) {
      return _then(_value.copyWith(weekly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RankingByPeriodCopyWith<$Res> get monthly {
    return $RankingByPeriodCopyWith<$Res>(_value.monthly, (value) {
      return _then(_value.copyWith(monthly: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RankingCopyWith<$Res> implements $RankingCopyWith<$Res> {
  factory _$$_RankingCopyWith(
          _$_Ranking value, $Res Function(_$_Ranking) then) =
      __$$_RankingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RankingByPeriod daily, RankingByPeriod weekly, RankingByPeriod monthly});

  @override
  $RankingByPeriodCopyWith<$Res> get daily;
  @override
  $RankingByPeriodCopyWith<$Res> get weekly;
  @override
  $RankingByPeriodCopyWith<$Res> get monthly;
}

/// @nodoc
class __$$_RankingCopyWithImpl<$Res>
    extends _$RankingCopyWithImpl<$Res, _$_Ranking>
    implements _$$_RankingCopyWith<$Res> {
  __$$_RankingCopyWithImpl(_$_Ranking _value, $Res Function(_$_Ranking) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daily = null,
    Object? weekly = null,
    Object? monthly = null,
  }) {
    return _then(_$_Ranking(
      daily: null == daily
          ? _value.daily
          : daily // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as RankingByPeriod,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Ranking extends _Ranking {
  const _$_Ranking(
      {required this.daily, required this.weekly, required this.monthly})
      : super._();

  factory _$_Ranking.fromJson(Map<String, dynamic> json) =>
      _$$_RankingFromJson(json);

/**
     * 日次のランキング
     */
  @override
  final RankingByPeriod daily;
/**
     * 週次のランキング
     */
  @override
  final RankingByPeriod weekly;
/**
     * 月次のランキング
     */
  @override
  final RankingByPeriod monthly;

  @override
  String toString() {
    return 'Ranking(daily: $daily, weekly: $weekly, monthly: $monthly)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Ranking &&
            (identical(other.daily, daily) || other.daily == daily) &&
            (identical(other.weekly, weekly) || other.weekly == weekly) &&
            (identical(other.monthly, monthly) || other.monthly == monthly));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, daily, weekly, monthly);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RankingCopyWith<_$_Ranking> get copyWith =>
      __$$_RankingCopyWithImpl<_$_Ranking>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RankingToJson(
      this,
    );
  }
}

abstract class _Ranking extends Ranking {
  const factory _Ranking(
      {required final RankingByPeriod daily,
      required final RankingByPeriod weekly,
      required final RankingByPeriod monthly}) = _$_Ranking;
  const _Ranking._() : super._();

  factory _Ranking.fromJson(Map<String, dynamic> json) = _$_Ranking.fromJson;

  @override
  /**
     * 日次のランキング
     */
  RankingByPeriod get daily;
  @override
  /**
     * 週次のランキング
     */
  RankingByPeriod get weekly;
  @override
  /**
     * 月次のランキング
     */
  RankingByPeriod get monthly;
  @override
  @JsonKey(ignore: true)
  _$$_RankingCopyWith<_$_Ranking> get copyWith =>
      throw _privateConstructorUsedError;
}
