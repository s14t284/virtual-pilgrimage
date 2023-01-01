
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_user.codegen.dart';

part 'ranking_by_period.codegen.freezed.dart';
part 'ranking_by_period.codegen.g.dart';

@freezed
class RankingByPeriod with _$RankingByPeriod {
  @JsonSerializable(explicitToJson: true)
  const factory RankingByPeriod({
    /**
     * 歩数のランキング
     */
    required RankingUsers step,

    /**
     * 歩行距離のランキング
     */
    required RankingUsers distance,

    /**
     * 更新時刻(unixtime[ms])
     */
    required int updatedTime,
  }) = _RankingByPeriod;

  const RankingByPeriod._();

  factory RankingByPeriod.fromJson(Map<String, dynamic> json) => _$RankingByPeriodFromJson(json);
}
