import 'package:virtualpilgrimage/domain/customizable_date_time.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/update_pilgrimage_progress_result.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/update_pilgrimage_progress_usecase.dart';
import 'package:virtualpilgrimage/domain/temple/temple_info.codegen.dart';
import 'package:virtualpilgrimage/domain/temple/temple_repository.dart';
import 'package:virtualpilgrimage/domain/user/health/health_by_period.codegen.dart';
import 'package:virtualpilgrimage/domain/user/health/health_repository.dart';
import 'package:virtualpilgrimage/domain/user/user_repository.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';

// お遍路の進捗を更新するUseCaseの実装
class UpdatePilgrimageProgressInteractor extends UpdatePilgrimageProgressUsecase {
  UpdatePilgrimageProgressInteractor(
    this._templeRepository,
    this._healthRepository,
    this._userRepository,
  );

  final TempleRepository _templeRepository;
  final HealthRepository _healthRepository;
  final UserRepository _userRepository;

  // 札所の数
  static const maxTempleNumber = 88;

  /// お遍路の進捗状況を更新
  ///
  /// [user] 更新対象のユーザ情報
  @override
  Future<UpdatePilgrimageProgressResult> execute(VirtualPilgrimageUser user) async {
    final now = CustomizableDateTime.current;
    final lastProgressUpdatedAt = user.pilgrimage.updatedAt;
    int lap = user.pilgrimage.lap;
    int nextPilgrimageId = _nextPilgrimageNumber(user.pilgrimage.nowPilgrimageId);

    // ロジックに利用する変数群
    late TempleInfo nowTempleInfo;
    late HealthByPeriod healthFromLastUpdatedAt;
    // 次の札所に向かうまでの移動距離を格納する変数
    // お遍路の進捗の更新のために利用
    int movingDistance;
    // 到達した札所のID一覧
    final List<int> reachedPilgrimageIdList = [];

    try {
      /// 1. 進捗を更新するために必要な情報を取得

      // 最大で2回外部通信する必要があるため、並列でまとめて実行
      // 現在、ユーザが目指している札所の情報と最終更新時間からのユーザのヘルスケア情報を取得
      await Future.wait(<Future<void>>[
        _templeRepository.getTempleInfo(nextPilgrimageId).then((value) => nowTempleInfo = value),
        _healthRepository
            .getHealthByPeriod(from: lastProgressUpdatedAt, to: now)
            .then((value) => healthFromLastUpdatedAt = value),
      ]);

      /// 2. 移動距離 > 次の札所までの距離 の間、で移動距離を減らしながら次に目指すべき札所を導出する
      movingDistance = healthFromLastUpdatedAt.distance;
      while (movingDistance >= nowTempleInfo.nextDistance) {
        reachedPilgrimageIdList.add(nowTempleInfo.id);
        // 札所までの距離を移動距離から引いて、札所を更新
        movingDistance -= nowTempleInfo.nextDistance;
        nextPilgrimageId = _nextPilgrimageNumber(nextPilgrimageId);
        // 次の札所が1番札所の時、1番札所からお遍路を再開する事になるため、以下の処理を行う
        // - lap を1増やす
        // - 1番札所から再スタートするため、次の目的地を2番札所に切り替える
        if (nextPilgrimageId == 1) {
          lap++;
          nextPilgrimageId = _nextPilgrimageNumber(nextPilgrimageId);
        }
        // NOTE: while で外部通信していて時間がかかるように見えるが、実際はキャッシュしたお寺の情報を問い合わせに行っているだけ
        nowTempleInfo = await _templeRepository.getTempleInfo(nextPilgrimageId);
      }

      /// 3. 導出した進捗状況でユーザ情報を更新
      final updatedPilgrimage = user.pilgrimage.copyWith(
        nowPilgrimageId: nextPilgrimageId,
        lap: lap,
        movingDistance: movingDistance,
        updatedAt: now,
      );
      await _userRepository.update(user.copyWith(pilgrimage: updatedPilgrimage, updatedAt: now));
    } on Exception catch (e) {
      return UpdatePilgrimageProgressResult(UpdatePilgrimageProgressResultStatus.fail, [], e);
    }

    return UpdatePilgrimageProgressResult(
      UpdatePilgrimageProgressResultStatus.success,
      reachedPilgrimageIdList,
    );
  }

  /// 次の札所の番号を返す
  /// 88箇所目に到達していたら 1 を返す
  /// [pilgrimageId] 現在の札所の番号
  int _nextPilgrimageNumber(int pilgrimageId) {
    if (pilgrimageId < maxTempleNumber) {
      return pilgrimageId + 1;
    }
    return 1;
  }
}
