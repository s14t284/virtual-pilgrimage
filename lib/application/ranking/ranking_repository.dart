import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firestore_provider.dart';
import 'package:virtualpilgrimage/infrastructure/ranking/ranking_repository_impl.dart';
import 'package:virtualpilgrimage/logger.dart';

final rankingRepositoryProvider = Provider<RankingRepository>(
  (ref) => RankingRepositoryImpl(ref.read(firestoreProvider), ref.read(loggerProvider)),
);

abstract class RankingRepository {
  Future<Ranking> get();
}
