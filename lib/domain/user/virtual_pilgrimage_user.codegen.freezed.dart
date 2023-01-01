// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'virtual_pilgrimage_user.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VirtualPilgrimageUser _$VirtualPilgrimageUserFromJson(
    Map<String, dynamic> json) {
  return _VirtualPilgrimageUser.fromJson(json);
}

/// @nodoc
mixin _$VirtualPilgrimageUser {
// ユーザID。Firebase Authentication によって自動生成
  String get id => throw _privateConstructorUsedError; // ニックネーム
  String get nickname => throw _privateConstructorUsedError; // 性別
  @JsonKey(
      fromJson: _GenderConverter.intToGender,
      toJson: _GenderConverter.genderToInt)
  Gender get gender => throw _privateConstructorUsedError; // 誕生日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get birthDay => throw _privateConstructorUsedError; // メールアドレス
  String get email => throw _privateConstructorUsedError; // ユーザのプロフィール画像のURL
  String get userIconUrl => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: _UserStatusConverter.intToUserStatus,
      toJson: _UserStatusConverter.userStatusToInt)
  UserStatus get userStatus => throw _privateConstructorUsedError; // ユーザの作成日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError; // ユーザの更新日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // ヘルスケア情報。歩数や移動距離など
  HealthInfo? get health =>
      throw _privateConstructorUsedError; // 現在地のお遍路で巡っているお寺の情報
  PilgrimageInfo get pilgrimage =>
      throw _privateConstructorUsedError; // 以下に json に変換した時に含めないパラメータを定義する
// DB で管理されずアプリ上で値がセットされる
// 設定する場合は @JsonKey(ignore: true) のようなアノテーションをつける
// map上のアイコン。ログイン時に userIconUrl から GoogleMap に描画できる形式に変換される
  @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
  BitmapDescriptor get mapIcon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VirtualPilgrimageUserCopyWith<VirtualPilgrimageUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VirtualPilgrimageUserCopyWith<$Res> {
  factory $VirtualPilgrimageUserCopyWith(VirtualPilgrimageUser value,
          $Res Function(VirtualPilgrimageUser) then) =
      _$VirtualPilgrimageUserCopyWithImpl<$Res, VirtualPilgrimageUser>;
  @useResult
  $Res call(
      {String id,
      String nickname,
      @JsonKey(fromJson: _GenderConverter.intToGender, toJson: _GenderConverter.genderToInt)
          Gender gender,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime birthDay,
      String email,
      String userIconUrl,
      @JsonKey(fromJson: _UserStatusConverter.intToUserStatus, toJson: _UserStatusConverter.userStatusToInt)
          UserStatus userStatus,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime updatedAt,
      HealthInfo? health,
      PilgrimageInfo pilgrimage,
      @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
          BitmapDescriptor mapIcon});

  $HealthInfoCopyWith<$Res>? get health;
  $PilgrimageInfoCopyWith<$Res> get pilgrimage;
}

/// @nodoc
class _$VirtualPilgrimageUserCopyWithImpl<$Res,
        $Val extends VirtualPilgrimageUser>
    implements $VirtualPilgrimageUserCopyWith<$Res> {
  _$VirtualPilgrimageUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? gender = null,
    Object? birthDay = null,
    Object? email = null,
    Object? userIconUrl = null,
    Object? userStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? health = freezed,
    Object? pilgrimage = null,
    Object? mapIcon = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthDay: null == birthDay
          ? _value.birthDay
          : birthDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userIconUrl: null == userIconUrl
          ? _value.userIconUrl
          : userIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      health: freezed == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as HealthInfo?,
      pilgrimage: null == pilgrimage
          ? _value.pilgrimage
          : pilgrimage // ignore: cast_nullable_to_non_nullable
              as PilgrimageInfo,
      mapIcon: null == mapIcon
          ? _value.mapIcon
          : mapIcon // ignore: cast_nullable_to_non_nullable
              as BitmapDescriptor,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HealthInfoCopyWith<$Res>? get health {
    if (_value.health == null) {
      return null;
    }

    return $HealthInfoCopyWith<$Res>(_value.health!, (value) {
      return _then(_value.copyWith(health: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PilgrimageInfoCopyWith<$Res> get pilgrimage {
    return $PilgrimageInfoCopyWith<$Res>(_value.pilgrimage, (value) {
      return _then(_value.copyWith(pilgrimage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VirtualPilgrimageUserCopyWith<$Res>
    implements $VirtualPilgrimageUserCopyWith<$Res> {
  factory _$$_VirtualPilgrimageUserCopyWith(_$_VirtualPilgrimageUser value,
          $Res Function(_$_VirtualPilgrimageUser) then) =
      __$$_VirtualPilgrimageUserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      @JsonKey(fromJson: _GenderConverter.intToGender, toJson: _GenderConverter.genderToInt)
          Gender gender,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime birthDay,
      String email,
      String userIconUrl,
      @JsonKey(fromJson: _UserStatusConverter.intToUserStatus, toJson: _UserStatusConverter.userStatusToInt)
          UserStatus userStatus,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          DateTime updatedAt,
      HealthInfo? health,
      PilgrimageInfo pilgrimage,
      @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
          BitmapDescriptor mapIcon});

  @override
  $HealthInfoCopyWith<$Res>? get health;
  @override
  $PilgrimageInfoCopyWith<$Res> get pilgrimage;
}

/// @nodoc
class __$$_VirtualPilgrimageUserCopyWithImpl<$Res>
    extends _$VirtualPilgrimageUserCopyWithImpl<$Res, _$_VirtualPilgrimageUser>
    implements _$$_VirtualPilgrimageUserCopyWith<$Res> {
  __$$_VirtualPilgrimageUserCopyWithImpl(_$_VirtualPilgrimageUser _value,
      $Res Function(_$_VirtualPilgrimageUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? gender = null,
    Object? birthDay = null,
    Object? email = null,
    Object? userIconUrl = null,
    Object? userStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? health = freezed,
    Object? pilgrimage = null,
    Object? mapIcon = null,
  }) {
    return _then(_$_VirtualPilgrimageUser(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthDay: null == birthDay
          ? _value.birthDay
          : birthDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userIconUrl: null == userIconUrl
          ? _value.userIconUrl
          : userIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      userStatus: null == userStatus
          ? _value.userStatus
          : userStatus // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      health: freezed == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as HealthInfo?,
      pilgrimage: null == pilgrimage
          ? _value.pilgrimage
          : pilgrimage // ignore: cast_nullable_to_non_nullable
              as PilgrimageInfo,
      mapIcon: null == mapIcon
          ? _value.mapIcon
          : mapIcon // ignore: cast_nullable_to_non_nullable
              as BitmapDescriptor,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_VirtualPilgrimageUser extends _VirtualPilgrimageUser {
  const _$_VirtualPilgrimageUser(
      {this.id = '',
      this.nickname = '',
      @JsonKey(fromJson: _GenderConverter.intToGender, toJson: _GenderConverter.genderToInt)
          this.gender = Gender.unknown,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required this.birthDay,
      this.email = '',
      this.userIconUrl = 'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/icon512.jpg?alt=media',
      @JsonKey(fromJson: _UserStatusConverter.intToUserStatus, toJson: _UserStatusConverter.userStatusToInt)
          this.userStatus = UserStatus.temporary,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required this.createdAt,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required this.updatedAt,
      this.health,
      required this.pilgrimage,
      @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
          this.mapIcon = BitmapDescriptor.defaultMarker})
      : super._();

  factory _$_VirtualPilgrimageUser.fromJson(Map<String, dynamic> json) =>
      _$$_VirtualPilgrimageUserFromJson(json);

// ユーザID。Firebase Authentication によって自動生成
  @override
  @JsonKey()
  final String id;
// ニックネーム
  @override
  @JsonKey()
  final String nickname;
// 性別
  @override
  @JsonKey(
      fromJson: _GenderConverter.intToGender,
      toJson: _GenderConverter.genderToInt)
  final Gender gender;
// 誕生日
  @override
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  final DateTime birthDay;
// メールアドレス
  @override
  @JsonKey()
  final String email;
// ユーザのプロフィール画像のURL
  @override
  @JsonKey()
  final String userIconUrl;
  @override
  @JsonKey(
      fromJson: _UserStatusConverter.intToUserStatus,
      toJson: _UserStatusConverter.userStatusToInt)
  final UserStatus userStatus;
// ユーザの作成日
  @override
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;
// ユーザの更新日
  @override
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  final DateTime updatedAt;
// ヘルスケア情報。歩数や移動距離など
  @override
  final HealthInfo? health;
// 現在地のお遍路で巡っているお寺の情報
  @override
  final PilgrimageInfo pilgrimage;
// 以下に json に変換した時に含めないパラメータを定義する
// DB で管理されずアプリ上で値がセットされる
// 設定する場合は @JsonKey(ignore: true) のようなアノテーションをつける
// map上のアイコン。ログイン時に userIconUrl から GoogleMap に描画できる形式に変換される
  @override
  @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
  final BitmapDescriptor mapIcon;

  @override
  String toString() {
    return 'VirtualPilgrimageUser(id: $id, nickname: $nickname, gender: $gender, birthDay: $birthDay, email: $email, userIconUrl: $userIconUrl, userStatus: $userStatus, createdAt: $createdAt, updatedAt: $updatedAt, health: $health, pilgrimage: $pilgrimage, mapIcon: $mapIcon)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VirtualPilgrimageUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDay, birthDay) ||
                other.birthDay == birthDay) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userIconUrl, userIconUrl) ||
                other.userIconUrl == userIconUrl) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.pilgrimage, pilgrimage) ||
                other.pilgrimage == pilgrimage) &&
            (identical(other.mapIcon, mapIcon) || other.mapIcon == mapIcon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      gender,
      birthDay,
      email,
      userIconUrl,
      userStatus,
      createdAt,
      updatedAt,
      health,
      pilgrimage,
      mapIcon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VirtualPilgrimageUserCopyWith<_$_VirtualPilgrimageUser> get copyWith =>
      __$$_VirtualPilgrimageUserCopyWithImpl<_$_VirtualPilgrimageUser>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VirtualPilgrimageUserToJson(
      this,
    );
  }
}

abstract class _VirtualPilgrimageUser extends VirtualPilgrimageUser {
  const factory _VirtualPilgrimageUser(
      {final String id,
      final String nickname,
      @JsonKey(fromJson: _GenderConverter.intToGender, toJson: _GenderConverter.genderToInt)
          final Gender gender,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required final DateTime birthDay,
      final String email,
      final String userIconUrl,
      @JsonKey(fromJson: _UserStatusConverter.intToUserStatus, toJson: _UserStatusConverter.userStatusToInt)
          final UserStatus userStatus,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdAt,
      @JsonKey(fromJson: FirestoreTimestampConverter.timestampToDateTime, toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
          required final DateTime updatedAt,
      final HealthInfo? health,
      required final PilgrimageInfo pilgrimage,
      @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
          final BitmapDescriptor mapIcon}) = _$_VirtualPilgrimageUser;
  const _VirtualPilgrimageUser._() : super._();

  factory _VirtualPilgrimageUser.fromJson(Map<String, dynamic> json) =
      _$_VirtualPilgrimageUser.fromJson;

  @override // ユーザID。Firebase Authentication によって自動生成
  String get id;
  @override // ニックネーム
  String get nickname;
  @override // 性別
  @JsonKey(
      fromJson: _GenderConverter.intToGender,
      toJson: _GenderConverter.genderToInt)
  Gender get gender;
  @override // 誕生日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get birthDay;
  @override // メールアドレス
  String get email;
  @override // ユーザのプロフィール画像のURL
  String get userIconUrl;
  @override
  @JsonKey(
      fromJson: _UserStatusConverter.intToUserStatus,
      toJson: _UserStatusConverter.userStatusToInt)
  UserStatus get userStatus;
  @override // ユーザの作成日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override // ユーザの更新日
  @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp)
  DateTime get updatedAt;
  @override // ヘルスケア情報。歩数や移動距離など
  HealthInfo? get health;
  @override // 現在地のお遍路で巡っているお寺の情報
  PilgrimageInfo get pilgrimage;
  @override // 以下に json に変換した時に含めないパラメータを定義する
// DB で管理されずアプリ上で値がセットされる
// 設定する場合は @JsonKey(ignore: true) のようなアノテーションをつける
// map上のアイコン。ログイン時に userIconUrl から GoogleMap に描画できる形式に変換される
  @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
  BitmapDescriptor get mapIcon;
  @override
  @JsonKey(ignore: true)
  _$$_VirtualPilgrimageUserCopyWith<_$_VirtualPilgrimageUser> get copyWith =>
      throw _privateConstructorUsedError;
}
