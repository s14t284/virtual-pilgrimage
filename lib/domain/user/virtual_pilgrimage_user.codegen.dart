import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:virtualpilgrimage/domain/customizable_date_time.dart';
import 'package:virtualpilgrimage/domain/helper/firestore_timestamp_converter.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/pilgrimage_info.codegen.dart';
import 'package:virtualpilgrimage/domain/user/health/health_info.codegen.dart';

part 'virtual_pilgrimage_user.codegen.freezed.dart';
part 'virtual_pilgrimage_user.codegen.g.dart';

// ログインしているユーザの状態
final userStateProvider = StateProvider<VirtualPilgrimageUser?>((_) => null);

// ユーザのログインステータス
// ログインステータスによって遷移できるページが変わってくるので、その遷移の為に利用
final loginStateProvider = StateProvider<UserStatus?>((_) => null);

// 性別
enum Gender {
  // 未設定
  unknown,
  // 男性
  man,
  // 女性
  woman,
}

// ユーザの作成状態のステータス
enum UserStatus {
  // 仮登録
  temporary,
  // 登録完了
  created,
  // 削除済み
  deleted
}

// User 情報の Firestore の key
extension VirtualPilgrimageUserPrivateFirestoreFieldKeys on String {
  static const id = 'id';
  static const nickname = 'nickname';
  static const gender = 'gender';
  static const birthDay = 'birthDay';
  static const email = 'email';
  static const userIconUrl = 'userIconUrl';
  static const userStatus = 'userStatus';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const health = 'health';
}

// Gender <-> int の相互変換用クラス
class _GenderConverter {
  static Gender intToGender(int num) => Gender.values[num];

  static int genderToInt(Gender gender) => gender.index;
}

// UserStatus <-> int の相互変換用クラス
class _UserStatusConverter {
  static UserStatus intToUserStatus(int num) => UserStatus.values[num];

  static int userStatusToInt(UserStatus userStatus) => userStatus.index;
}

// Bitmapへの変換用クラス
class _BitmapConverter {
  static BitmapDescriptor stringToBitmap(String string) =>
      BitmapDescriptor.fromBytes(Uint8List.fromList(string.codeUnits));
}

@freezed
class VirtualPilgrimageUser with _$VirtualPilgrimageUser {
  @JsonSerializable(explicitToJson: true)
  const factory VirtualPilgrimageUser({
    // ユーザID。Firebase Authentication によって自動生成
    @Default('')
        String id,
    // ニックネーム
    @Default('')
        String nickname,
    // 性別
    @JsonKey(fromJson: _GenderConverter.intToGender, toJson: _GenderConverter.genderToInt)
    @Default(Gender.unknown)
        Gender gender,
    // 誕生日
    @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime birthDay,
    // メールアドレス
    @Default('')
        String email,
    // ユーザのプロフィール画像のURL
    @Default('https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/icon512.jpg?alt=media')
        String userIconUrl,
    @Default(UserStatus.temporary)
    // ユーザの登録状態
    @JsonKey(
      fromJson: _UserStatusConverter.intToUserStatus,
      toJson: _UserStatusConverter.userStatusToInt,
    )
        UserStatus userStatus,
    // ユーザの作成日
    @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
    // ユーザの更新日
    @JsonKey(
      fromJson: FirestoreTimestampConverter.timestampToDateTime,
      toJson: FirestoreTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime updatedAt,
    // ヘルスケア情報。歩数や移動距離など
    HealthInfo? health,
    // 現在地のお遍路で巡っているお寺の情報
    required PilgrimageInfo pilgrimage,

    // 以下に json に変換した時に含めないパラメータを定義する
    // DB で管理されずアプリ上で値がセットされる
    // 設定する場合は @JsonKey(ignore: true) のようなアノテーションをつける

    // map上のアイコン。ログイン時に userIconUrl から GoogleMap に描画できる形式に変換される
    @JsonKey(ignore: true, fromJson: _BitmapConverter.stringToBitmap)
    @Default(BitmapDescriptor.defaultMarker)
        BitmapDescriptor mapIcon,
  }) = _VirtualPilgrimageUser;

  const VirtualPilgrimageUser._();

  factory VirtualPilgrimageUser.fromJson(Map<String, dynamic> json) =>
      _$VirtualPilgrimageUserFromJson(json);

  /// 初回のサインイン時に設定するユーザ情報を作成
  ///
  /// [credentialUser] firebase authentication でサインインした時に生成されるユーザ情報
  // ignore: prefer_constructors_over_static_methods
  static VirtualPilgrimageUser initializeForSignIn(User credentialUser) {
    final now = CustomizableDateTime.current;
    String defaultProfileImageUrl() {
      const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
      switch (flavor) {
        case 'prod':
          return 'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-prd.appspot.com/o/icon512.jpg?alt=media';
        case 'dev':
        default:
          return 'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/icon512.jpg?alt=media';
      }
    }

    final userIconUrl = credentialUser.photoURL ?? defaultProfileImageUrl();
    return VirtualPilgrimageUser(
      id: credentialUser.uid,
      birthDay: DateTime.utc(1980, 1, 1),
      // email はどのログイン方法でも必ず存在するはず
      email: credentialUser.email!,
      userStatus: UserStatus.temporary,
      createdAt: now,
      updatedAt: now,
      userIconUrl: userIconUrl,
      pilgrimage: PilgrimageInfo(
        id: credentialUser.uid,
        updatedAt: now,
      ),
    );
  }

  /// ユーザ登録フォームから入力されたユーザ情報を更新
  VirtualPilgrimageUser fromRegistrationForm(String nickname, Gender gender, DateTime birthday) =>
      copyWith(
        nickname: nickname,
        gender: gender,
        birthDay: birthday,
        userStatus: UserStatus.created,
      );

  /// ユーザ登録が完了したため作成済みステータスに変更
  VirtualPilgrimageUser toRegistration() => copyWith(userStatus: UserStatus.created);

  /// ヘルスケア情報を更新
  VirtualPilgrimageUser updateHealth(HealthInfo health) => copyWith(health: health);

  /// お遍路の進捗を更新
  VirtualPilgrimageUser updatePilgrimageProgress(
    int pilgrimageId,
    int lap,
    int movingDistance,
    DateTime updatedAt,
  ) =>
      copyWith(
        pilgrimage:
            pilgrimage.updatePilgrimageProgress(pilgrimageId, lap, movingDistance, updatedAt),
        updatedAt: updatedAt,
      );

  /// プロフィール画像のURLを更新
  VirtualPilgrimageUser updateUserIconUrl(String userIconUrl) => copyWith(
        userIconUrl: userIconUrl,
        updatedAt: CustomizableDateTime.current,
      );

  VirtualPilgrimageUser toDelete() => copyWith(userStatus: UserStatus.deleted);
}
