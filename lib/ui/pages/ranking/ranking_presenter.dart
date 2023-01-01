import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:virtualpilgrimage/application/ranking/ranking_repository.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_by_period.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_user.codegen.dart';
import 'package:virtualpilgrimage/router.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/ranking_state.codegen.dart';
import 'package:virtualpilgrimage/ui/wording_helper.dart';

/// ランキングを集計する項目
enum RankingKind { steps, distances }

/// ランキングを集計する期間
enum RankingPeriod { daily, weekly, monthly }

/// ランキング情報を外部通信によって取得するprovider
final rankingProvider = FutureProvider<Ranking>((ref) async {
  final repository = ref.read(rankingRepositoryProvider);
  return repository.get();
});

/// ランキング情報表示に利用するUIのprovider
final rankingPresenterProvider =
    StateNotifierProvider.autoDispose<RankingPresenter, RankingState>(RankingPresenter.new);

class RankingPresenter extends StateNotifier<RankingState> {
  RankingPresenter(this._ref) : super(RankingState());

  final Ref _ref;

  final _periodTabLabels = ['昨日', '週間', '月間'];

  List<String> get periodTabLabels => _periodTabLabels;

  final dateFormat = DateFormat('yyyy/MM/dd');

  /// 表示するランキング情報を選択する
  RankingUsers selectRanking(Ranking ranking, RankingKind kind, RankingPeriod period) {
    switch (kind) {
      case RankingKind.steps:
        return _selectRankingByPeriod(ranking, period).step;
      case RankingKind.distances:
        return _selectRankingByPeriod(ranking, period).distance;
    }
  }

  /// 参照しているランキング情報の期間を選択する
  RankingByPeriod _selectRankingByPeriod(Ranking ranking, RankingPeriod period) {
    switch (period) {
      case RankingPeriod.daily:
        return ranking.daily;
      case RankingPeriod.weekly:
        return ranking.weekly;
      case RankingPeriod.monthly:
        return ranking.monthly;
    }
  }

  /// 集計した時間を表示形式に変換する
  String convertUpdatedTimeToDisplayFormat(Ranking? ranking, RankingPeriod period) {
    if (ranking == null) {
      return '不明';
    }
    final rankingByPeriod = _selectRankingByPeriod(ranking, period);
    final dateTime = DateTime.fromMillisecondsSinceEpoch(rankingByPeriod.updatedTime);
    return dateFormat.format(dateTime);
  }

  /// 歩数または距離を表示形式に変換する
  String convertRankingValueDisplayFormat(int value, RankingKind kind) {
    switch (kind) {
      case RankingKind.steps:
        return '$value 歩';
      case RankingKind.distances:
        return '${WordingHelper.meterToKilometerString(value)} km';
    }
  }

  /// プロフィールページに遷移する
  Future<void> moveProfilePage(String userId) async => _ref.read(routerProvider).pushNamed(
        RouterPath.profile,
        queryParams: {
          'userId': userId,
          'canEdit': 'false',
          'previousPagePath': RouterPath.ranking,
        },
      );

  /// デフォルトのプロフィール画像
  String get defaultProfileImageUrl {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    switch (flavor) {
      case 'prod':
        return 'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-prd.appspot.com/o/icon512.jpg?alt=media';
      case 'dev':
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/virtual-pilgrimage-dev.appspot.com/o/icon512.jpg?alt=media';
    }
  }
}
