// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_user.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RankingUsers _$$_RankingUsersFromJson(Map<String, dynamic> json) =>
    _$_RankingUsers(
      users: (json['users'] as List<dynamic>)
          .map((e) => RankingUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_RankingUsersToJson(_$_RankingUsers instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

_$_RankingUser _$$_RankingUserFromJson(Map<String, dynamic> json) =>
    _$_RankingUser(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      userIconUrl: json['userIconUrl'] as String,
      value: json['value'] as int,
      rank: json['rank'] as int,
    );

Map<String, dynamic> _$$_RankingUserToJson(_$_RankingUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'userIconUrl': instance.userIconUrl,
      'value': instance.value,
      'rank': instance.rank,
    };
