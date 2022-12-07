import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/temple_info.codegen.dart';

part 'temple_state.codegen.freezed.dart';

@freezed
class TempleState with _$TempleState {
  const factory TempleState({
    @Default([]) List<TempleInfo> temples,
    required ScrollController scrollController,
  }) = _TempleState;

  const TempleState._();

  TempleState updateTemples(List<TempleInfo> temples) => copyWith(temples: temples);

  void addListener(VoidCallback listener) => scrollController.addListener(listener);
}
