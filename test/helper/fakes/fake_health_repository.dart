import 'package:virtualpilgrimage/domain/user/health/health_by_period.codegen.dart';
import 'package:virtualpilgrimage/domain/user/health/health_info.codegen.dart';
import 'package:virtualpilgrimage/application/user/health/health_repository.dart';

class FakeHealthRepository extends HealthRepository {
  FakeHealthRepository({required this.healthByPeriod, required this.healthInfo});

  final HealthByPeriod healthByPeriod;
  final HealthInfo healthInfo;

  @override
  Future<HealthByPeriod> getHealthByPeriod({required DateTime from, required DateTime to}) {
    return Future.value(healthByPeriod);
  }

  @override
  Future<HealthInfo> getHealthInfo({
    required DateTime targetDateTime,
    required DateTime createdAt,
  }) {
    return Future.value(healthInfo);
  }
}
