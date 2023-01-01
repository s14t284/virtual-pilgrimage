// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ranking_by_period.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RankingByPeriod _$RankingByPeriodFromJson(Map<String, dynamic> json) {
  return _RankingByPeriod.fromJson(json);
}

/// @nodoc
mixin _$RankingByPeriod {
/**
     * 歩数のランキング
     */
  RankingUsers get step => throw _privateConstructorUsedError;
  /**
     * 歩行距離のランキング
     */
  RankingUsers get distance => throw _privateConstructorUsedError;
  /**
     * 更新時刻(unixtime[ms])
     */
  int get updatedTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RankingByPeriodCopyWith<RankingByPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingByPeriodCopyWith<$Res> {
  factory $RankingByPeriodCopyWith(
          RankingByPeriod value, $Res Function(RankingByPeriod) then) =
      _$RankingByPeriodCopyWithImpl<$Res, RankingByPeriod>;
  @useResult
  $Res call({RankingUsers step, RankingUsers distance, int updatedTime});

  $RankingUsersCopyWith<$Res> get step;
  $RankingUsersCopyWith<$Res> get distance;
}

/// @nodoc
class _$RankingByPeriodCopyWithImpl<$Res, $Val extends RankingByPeriod>
    implements $RankingByPeriodCopyWith<$Res> {
  _$RankingByPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? distance = null,
    Object? updatedTime = null,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as RankingUsers,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as RankingUsers,
      updatedTime: null == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RankingUsersCopyWith<$Res> get step {
    return $RankingUsersCopyWith<$Res>(_value.step, (value) {
      return _then(_value.copyWith(step: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RankingUsersCopyWith<$Res> get distance {
    return $RankingUsersCopyWith<$Res>(_value.distance, (value) {
      return _then(_value.copyWith(distance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RankingByPeriodCopyWith<$Res>
    implements $RankingByPeriodCopyWith<$Res> {
  factory _$$_RankingByPeriodCopyWith(
          _$_RankingByPeriod value, $Res Function(_$_RankingByPeriod) then) =
      __$$_RankingByPeriodCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RankingUsers step, RankingUsers distance, int updatedTime});

  @override
  $RankingUsersCopyWith<$Res> get step;
  @override
  $RankingUsersCopyWith<$Res> get distance;
}

/// @nodoc
class __$$_RankingByPeriodCopyWithImpl<$Res>
    extends _$RankingByPeriodCopyWithImpl<$Res, _$_RankingByPeriod>
    implements _$$_RankingByPeriodCopyWith<$Res> {
  __$$_RankingByPeriodCopyWithImpl(
      _$_RankingByPeriod _value, $Res Function(_$_RankingByPeriod) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? distance = null,
    Object? updatedTime = null,
  }) {
    return _then(_$_RankingByPeriod(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as RankingUsers,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as RankingUsers,
      updatedTime: null == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_RankingByPeriod extends _RankingByPeriod {
  const _$_RankingByPeriod(
      {required this.step, required this.distance, required this.updatedTime})
      : super._();

  factory _$_RankingByPeriod.fromJson(Map<String, dynamic> json) =>
      _$$_RankingByPeriodFromJson(json);

/**
     * 歩数のランキング
     */
  @override
  final RankingUsers step;
/**
     * 歩行距離のランキング
     */
  @override
  final RankingUsers distance;
/**
     * 更新時刻(unixtime[ms])
     */
  @override
  final int updatedTime;

  @override
  String toString() {
    return 'RankingByPeriod(step: $step, distance: $distance, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RankingByPeriod &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, step, distance, updatedTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RankingByPeriodCopyWith<_$_RankingByPeriod> get copyWith =>
      __$$_RankingByPeriodCopyWithImpl<_$_RankingByPeriod>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RankingByPeriodToJson(
      this,
    );
  }
}

abstract class _RankingByPeriod extends RankingByPeriod {
  const factory _RankingByPeriod(
      {required final RankingUsers step,
      required final RankingUsers distance,
      required final int updatedTime}) = _$_RankingByPeriod;
  const _RankingByPeriod._() : super._();

  factory _RankingByPeriod.fromJson(Map<String, dynamic> json) =
      _$_RankingByPeriod.fromJson;

  @override
  /**
     * 歩数のランキング
     */
  RankingUsers get step;
  @override
  /**
     * 歩行距離のランキング
     */
  RankingUsers get distance;
  @override
  /**
     * 更新時刻(unixtime[ms])
     */
  int get updatedTime;
  @override
  @JsonKey(ignore: true)
  _$$_RankingByPeriodCopyWith<_$_RankingByPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}
