// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_by_period.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RankingByPeriod _$$_RankingByPeriodFromJson(Map<String, dynamic> json) =>
    _$_RankingByPeriod(
      step: RankingUsers.fromJson(json['step'] as Map<String, dynamic>),
      distance: RankingUsers.fromJson(json['distance'] as Map<String, dynamic>),
      updatedTime: json['updatedTime'] as int,
    );

Map<String, dynamic> _$$_RankingByPeriodToJson(_$_RankingByPeriod instance) =>
    <String, dynamic>{
      'step': instance.step.toJson(),
      'distance': instance.distance.toJson(),
      'updatedTime': instance.updatedTime,
    };
