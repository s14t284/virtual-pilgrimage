// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Ranking _$$_RankingFromJson(Map<String, dynamic> json) => _$_Ranking(
      daily: RankingByPeriod.fromJson(json['daily'] as Map<String, dynamic>),
      weekly: RankingByPeriod.fromJson(json['weekly'] as Map<String, dynamic>),
      monthly:
          RankingByPeriod.fromJson(json['monthly'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RankingToJson(_$_Ranking instance) =>
    <String, dynamic>{
      'daily': instance.daily.toJson(),
      'weekly': instance.weekly.toJson(),
      'monthly': instance.monthly.toJson(),
    };
