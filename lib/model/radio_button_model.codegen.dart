import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_button_model.codegen.freezed.dart';

@freezed
class RadioButtonModel<T> with _$RadioButtonModel<T> {
  RadioButtonModel._();

  factory RadioButtonModel({
    required List<FocusNode> focusNodes,
    required List<String> titles,
    required List<T> values,
    required T selectedValue,
  }) = _RadioButtonModel<T>;

  void unfocus() => focusNodes.map((e) => e.unfocus());

  static RadioButtonModel<T> of<T>(List<String> titles, List<T> values) {
    if (titles.length != values.length) {
      throw ArgumentError(
          'length of titles and values must be same [titles][${titles.length}][values][${values.length}]');
    }
    final focusNodes = <FocusNode>[];
    for (int i = 0; i < titles.length; i++) {
      focusNodes.add(FocusNode());
    }
    return RadioButtonModel(
      focusNodes: focusNodes,
      titles: titles,
      values: values,
      selectedValue: values[0],
    );
  }
}
