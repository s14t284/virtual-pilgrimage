import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/model/radio_button_model.codegen.dart';

part 'registration_state.codegen.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const RegistrationState._();

  const factory RegistrationState({
    required FormModel nickname,
    required RadioButtonModel<Gender> gender,
    required DateTime birthDay,
  }) = _RegistrationState;

  RegistrationState onSubmit() => copyWith(nickname: nickname.onSubmit());
}
