import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_state.codegen.freezed.dart';

@freezed
class RankingState with _$RankingState {
  factory RankingState() = _RankingState;

  const RankingState._();
}
