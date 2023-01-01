
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_user.codegen.freezed.dart';
part 'ranking_user.codegen.g.dart';

@freezed
class RankingUsers with _$RankingUsers {
  @JsonSerializable(explicitToJson: true)
  const factory RankingUsers({
    /**
     * ランキング順にソートされたユーザ一覧
     */
    required List<RankingUser> users,
  }) = _RankingUsers;

  const RankingUsers._();

  factory RankingUsers.fromJson(Map<String, dynamic> json) => _$RankingUsersFromJson(json);
}

@freezed
class RankingUser with _$RankingUser {
  @JsonSerializable()
  const factory RankingUser({
    /**
     * ユーザID
     */
    required String userId,

    /**
     * ニックネーム
     */
    required String nickname,

    /**
     * ニックネーム
     */
    required String userIconUrl,

    /**
     * 歩数または歩行距離
     */
    required int value,

    /**
     * 順位
     */
    required int rank,
  }) = _RankingUser;

  const RankingUser._();

  factory RankingUser.fromJson(Map<String, dynamic> json) => _$RankingUserFromJson(json);
}
