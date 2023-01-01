import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:virtualpilgrimage/application/ranking/ranking_repository.dart';
import 'package:virtualpilgrimage/domain/exception/database_exception.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_by_period.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firestore_collection_path.dart';

class RankingRepositoryImpl extends RankingRepository {
  RankingRepositoryImpl(this._firestoreClient, this._logger);

  final FirebaseFirestore _firestoreClient;
  final Logger _logger;

  @override
  Future<Ranking> get() async {
    try {
      _logger.d('get ranking from Firestore');
      final result = await _firestoreClient
          .collection(FirestoreCollectionPath.rankings)
          .withConverter<RankingByPeriod>(
            fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
                RankingByPeriod.fromJson(snapshot.data()!),
            toFirestore: (RankingByPeriod r, _) => r.toJson(),
          )
          .get();
      final Map<String, RankingByPeriod> rankingByPeriodMap = {};
      // daily, weekly, monthly に分けてデータが格納されているので、ドメインエンティティに詰め替える
      for (final QueryDocumentSnapshot<RankingByPeriod> snapshot in result.docs) {
        rankingByPeriodMap[snapshot.id] = snapshot.data();
      }
      return Ranking.fromRankingByPeriodMap(rankingByPeriodMap);
    } on FirebaseException catch (e) {
      throw DatabaseException(
        message: 'cause Firestore error [code][${e.code}][message][${e.message}]',
        cause: e,
      );
    } on Exception catch (e) {
      throw DatabaseException(
        message: 'unexpected Firestore error ${e.toString()}',
        cause: e,
      );
    }
  }
}
