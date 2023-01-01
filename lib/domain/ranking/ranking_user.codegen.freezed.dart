// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ranking_user.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RankingUsers _$RankingUsersFromJson(Map<String, dynamic> json) {
  return _RankingUsers.fromJson(json);
}

/// @nodoc
mixin _$RankingUsers {
/**
     * ランキング順にソートされたユーザ一覧
     */
  List<RankingUser> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RankingUsersCopyWith<RankingUsers> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingUsersCopyWith<$Res> {
  factory $RankingUsersCopyWith(
          RankingUsers value, $Res Function(RankingUsers) then) =
      _$RankingUsersCopyWithImpl<$Res, RankingUsers>;
  @useResult
  $Res call({List<RankingUser> users});
}

/// @nodoc
class _$RankingUsersCopyWithImpl<$Res, $Val extends RankingUsers>
    implements $RankingUsersCopyWith<$Res> {
  _$RankingUsersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<RankingUser>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RankingUsersCopyWith<$Res>
    implements $RankingUsersCopyWith<$Res> {
  factory _$$_RankingUsersCopyWith(
          _$_RankingUsers value, $Res Function(_$_RankingUsers) then) =
      __$$_RankingUsersCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RankingUser> users});
}

/// @nodoc
class __$$_RankingUsersCopyWithImpl<$Res>
    extends _$RankingUsersCopyWithImpl<$Res, _$_RankingUsers>
    implements _$$_RankingUsersCopyWith<$Res> {
  __$$_RankingUsersCopyWithImpl(
      _$_RankingUsers _value, $Res Function(_$_RankingUsers) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
  }) {
    return _then(_$_RankingUsers(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<RankingUser>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_RankingUsers extends _RankingUsers {
  const _$_RankingUsers({required final List<RankingUser> users})
      : _users = users,
        super._();

  factory _$_RankingUsers.fromJson(Map<String, dynamic> json) =>
      _$$_RankingUsersFromJson(json);

/**
     * ランキング順にソートされたユーザ一覧
     */
  final List<RankingUser> _users;
/**
     * ランキング順にソートされたユーザ一覧
     */
  @override
  List<RankingUser> get users {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'RankingUsers(users: $users)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RankingUsers &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RankingUsersCopyWith<_$_RankingUsers> get copyWith =>
      __$$_RankingUsersCopyWithImpl<_$_RankingUsers>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RankingUsersToJson(
      this,
    );
  }
}

abstract class _RankingUsers extends RankingUsers {
  const factory _RankingUsers({required final List<RankingUser> users}) =
      _$_RankingUsers;
  const _RankingUsers._() : super._();

  factory _RankingUsers.fromJson(Map<String, dynamic> json) =
      _$_RankingUsers.fromJson;

  @override
  /**
     * ランキング順にソートされたユーザ一覧
     */
  List<RankingUser> get users;
  @override
  @JsonKey(ignore: true)
  _$$_RankingUsersCopyWith<_$_RankingUsers> get copyWith =>
      throw _privateConstructorUsedError;
}

RankingUser _$RankingUserFromJson(Map<String, dynamic> json) {
  return _RankingUser.fromJson(json);
}

/// @nodoc
mixin _$RankingUser {
/**
     * ユーザID
     */
  String get userId => throw _privateConstructorUsedError;
  /**
     * ニックネーム
     */
  String get nickname => throw _privateConstructorUsedError;
  /**
     * ニックネーム
     */
  String get userIconUrl => throw _privateConstructorUsedError;
  /**
     * 歩数または歩行距離
     */
  int get value => throw _privateConstructorUsedError;
  /**
     * 順位
     */
  int get rank => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RankingUserCopyWith<RankingUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingUserCopyWith<$Res> {
  factory $RankingUserCopyWith(
          RankingUser value, $Res Function(RankingUser) then) =
      _$RankingUserCopyWithImpl<$Res, RankingUser>;
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String userIconUrl,
      int value,
      int rank});
}

/// @nodoc
class _$RankingUserCopyWithImpl<$Res, $Val extends RankingUser>
    implements $RankingUserCopyWith<$Res> {
  _$RankingUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? userIconUrl = null,
    Object? value = null,
    Object? rank = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      userIconUrl: null == userIconUrl
          ? _value.userIconUrl
          : userIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RankingUserCopyWith<$Res>
    implements $RankingUserCopyWith<$Res> {
  factory _$$_RankingUserCopyWith(
          _$_RankingUser value, $Res Function(_$_RankingUser) then) =
      __$$_RankingUserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String userIconUrl,
      int value,
      int rank});
}

/// @nodoc
class __$$_RankingUserCopyWithImpl<$Res>
    extends _$RankingUserCopyWithImpl<$Res, _$_RankingUser>
    implements _$$_RankingUserCopyWith<$Res> {
  __$$_RankingUserCopyWithImpl(
      _$_RankingUser _value, $Res Function(_$_RankingUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? userIconUrl = null,
    Object? value = null,
    Object? rank = null,
  }) {
    return _then(_$_RankingUser(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      userIconUrl: null == userIconUrl
          ? _value.userIconUrl
          : userIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable()
class _$_RankingUser extends _RankingUser {
  const _$_RankingUser(
      {required this.userId,
      required this.nickname,
      required this.userIconUrl,
      required this.value,
      required this.rank})
      : super._();

  factory _$_RankingUser.fromJson(Map<String, dynamic> json) =>
      _$$_RankingUserFromJson(json);

/**
     * ユーザID
     */
  @override
  final String userId;
/**
     * ニックネーム
     */
  @override
  final String nickname;
/**
     * ニックネーム
     */
  @override
  final String userIconUrl;
/**
     * 歩数または歩行距離
     */
  @override
  final int value;
/**
     * 順位
     */
  @override
  final int rank;

  @override
  String toString() {
    return 'RankingUser(userId: $userId, nickname: $nickname, userIconUrl: $userIconUrl, value: $value, rank: $rank)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RankingUser &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.userIconUrl, userIconUrl) ||
                other.userIconUrl == userIconUrl) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, userIconUrl, value, rank);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RankingUserCopyWith<_$_RankingUser> get copyWith =>
      __$$_RankingUserCopyWithImpl<_$_RankingUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RankingUserToJson(
      this,
    );
  }
}

abstract class _RankingUser extends RankingUser {
  const factory _RankingUser(
      {required final String userId,
      required final String nickname,
      required final String userIconUrl,
      required final int value,
      required final int rank}) = _$_RankingUser;
  const _RankingUser._() : super._();

  factory _RankingUser.fromJson(Map<String, dynamic> json) =
      _$_RankingUser.fromJson;

  @override
  /**
     * ユーザID
     */
  String get userId;
  @override
  /**
     * ニックネーム
     */
  String get nickname;
  @override
  /**
     * ニックネーム
     */
  String get userIconUrl;
  @override
  /**
     * 歩数または歩行距離
     */
  int get value;
  @override
  /**
     * 順位
     */
  int get rank;
  @override
  @JsonKey(ignore: true)
  _$$_RankingUserCopyWith<_$_RankingUser> get copyWith =>
      throw _privateConstructorUsedError;
}
