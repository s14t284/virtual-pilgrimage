import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/model/radio_button_model.codegen.dart';
import 'package:virtualpilgrimage/ui/pages/registration/registration_state.codegen.dart';

final registrationPresenterProvider =
    StateNotifierProvider.autoDispose<RegistrationPresenter, RegistrationState>(
  (ref) => RegistrationPresenter(ref, ref.watch(userStateProvider)),
);

class RegistrationPresenter extends StateNotifier<RegistrationState> {
  final Ref _ref;

  RegistrationPresenter(this._ref, VirtualPilgrimageUser? user)
      : super(RegistrationState(
          nickname: FormModel.of(nicknameValidator),
          gender: RadioButtonModel.of<Gender>(
            ['未設定', '男性', '女性'],
            Gender.values,
          ),
          birthDay: user != null ? user.birthDay : DateTime.utc(1980),
        ));

  void initialize(String nickname, DateTime birthday) {
    state = RegistrationState(
        nickname: FormModel.of(nicknameValidator, nickname),
        gender: RadioButtonModel.of<Gender>(['未設定', '男性', '女性'], Gender.values),
        birthDay: birthday);
  }

  void onChangedNickname(FormModel nickname) =>
      state = state.copyWith(nickname: nickname);

  void onChangedGender(Gender? gender) {
    state.nickname.unfocus();
    state = state.copyWith(
      gender: state.gender.copyWith(selectedValue: gender!),
    );
  }
}
