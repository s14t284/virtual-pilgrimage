
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_by_period.codegen.dart';

part 'ranking.codegen.freezed.dart';
part 'ranking.codegen.g.dart';

@freezed
class Ranking with _$Ranking {
  @JsonSerializable(explicitToJson: true)
  const factory Ranking({
    /**
     * 日次のランキング
     */
    required RankingByPeriod daily,

    /**
     * 週次のランキング
     */
    required RankingByPeriod weekly,

    /**
     * 月次のランキング
     */
    required RankingByPeriod monthly,
  }) = _Ranking;

  const Ranking._();

  factory Ranking.fromJson(Map<String, dynamic> json) => _$RankingFromJson(json);

  /// DBから取得したデータからRankingクラスに変換
  /// [map] DBから取得したデータ
  ///
  // ignore: prefer_constructors_over_static_methods
  static Ranking fromRankingByPeriodMap(Map<String, RankingByPeriod> map) {
    if(map.containsKey('daily') && map.containsKey('weekly') && map.containsKey('monthly')) {
      return Ranking(daily: map['daily']!, weekly: map['weekly']!, monthly: map['monthly']!);
    }
    throw NullThrownError();
  }
}
