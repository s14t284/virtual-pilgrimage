import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:virtualpilgrimage/analytics.dart';
import 'package:virtualpilgrimage/domain/user/registration/registration_result.dart';
import 'package:virtualpilgrimage/domain/user/registration/user_registration_usecase.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_crashlytics_provider.dart';
import 'package:virtualpilgrimage/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/model/radio_button_model.codegen.dart';
import 'package:virtualpilgrimage/ui/pages/registration/registration_state.codegen.dart';
import 'package:virtualpilgrimage/ui/style/color.dart';

final registrationPresenterProvider =
    StateNotifierProvider.autoDispose<RegistrationPresenter, RegistrationState>(
  (ref) => RegistrationPresenter(ref, ref.watch(userStateProvider)),
);

class RegistrationPresenter extends StateNotifier<RegistrationState> {
  RegistrationPresenter(this._ref, VirtualPilgrimageUser? user)
      : super(
          RegistrationState(
            nickname: FormModel.of(nicknameValidator, user?.nickname ?? ''),
            birthday: FormModel.of(
              birthdayValidator,
              user != null ? DateFormat('yyyyMMdd').format(user.birthDay) : '',
            ),
            gender: RadioButtonModel.of<Gender>(
              ['未設定', '男性', '女性'],
              Gender.values,
              selectedValue: user?.gender,
              colors: [
                ColorModel(
                  lightColor: ColorStyle.unknownGenderLight,
                  darkColor: ColorStyle.unknownGenderDark,
                ),
                ColorModel(lightColor: ColorStyle.manLight, darkColor: ColorStyle.manDark),
                ColorModel(lightColor: ColorStyle.womanLight, darkColor: ColorStyle.womanDark),
              ],
            ),
          ),
        ) {
    _usecase = _ref.read(userRegistrationUsecaseProvider);
    _analytics = _ref.read(analyticsProvider);
    _crashlytics = _ref.read(firebaseCrashlyticsProvider);
    _userState = _ref.watch(userStateProvider.notifier);
    _loginState = _ref.watch(loginStateProvider.state);
  }

  final Ref _ref;
  late final UserRegistrationUsecase _usecase;
  late final Analytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final StateController<VirtualPilgrimageUser?> _userState;
  late final StateController<UserStatus?> _loginState;
  final dateFormatter = DateFormat();

  void onChangedNickname(FormModel nickname) {
    state = state.onChangeNickname(nickname);
  }

  void onChangedBirthday(FormModel birthday) {
    state = state.onChangeBirthday(birthday);
  }

  void onChangedGender(Gender? gender) {
    state = state.onTapGenderButton(gender!);
  }

  Future<void> onPressedRegistration() async {
    final defaultParams = {
      'nickname': state.nickname.text,
      'gender': state.gender.selectedValue.name,
      'birthday': state.birthday.text,
    };
    await _analytics.logEvent(
      eventName: AnalyticsEvent.pressedRegistration,
      parameters: defaultParams,
    );
    state = state.onSubmit();
    // バリデーションエラーにかかっている場合はリクエストを送らない
    if (!state.nickname.isValid || !state.birthday.isValid) {
      unawaited(
        _analytics.logEvent(
          eventName: AnalyticsEvent.registrationFailed,
          parameters: {
            ...defaultParams,
            'nicknameValidationError': state.nickname.displayError ?? '',
            'birthdayValidationError': state.birthday.displayError ?? '',
          },
        ),
      );
      return;
    }

    late DateTime birthday;
    try {
      birthday = DateTime.parse(state.birthday.text);
    } on FormatException catch (e) {
      state = state.setExternalErrors(birthdayError: '生年月日の形式が不正です');
      unawaited(
        _analytics.logEvent(
          eventName: AnalyticsEvent.registrationFailed,
          parameters: {
            ...defaultParams,
            'nicknameValidationError': state.nickname.displayError ?? '',
            'birthdayValidationError': state.birthday.displayError ?? '',
          },
        ),
      );
      unawaited(_crashlytics.recordError(e, null));
      return;
    }

    final user = _ref.read(userStateProvider)!;
    final updatedUser =
        user.fromRegistrationForm(state.nickname.text, state.gender.selectedValue, birthday);
    final result = await _usecase.execute(updatedUser);

    switch (result.status) {
      // ユーザ登録に成功したらユーザの state を更新
      case RegistrationResultStatus.success:
        _userState.state = updatedUser;
        _loginState.state = updatedUser.userStatus;
        break;
      case RegistrationResultStatus.alreadyExistSameNicknameUser:
        state = state.setExternalErrors(nicknameError: '既に使われているため別のニックネームにしてください');
        unawaited(
          _analytics.logEvent(
            eventName: AnalyticsEvent.registrationFailed,
            parameters: {...defaultParams, 'status': result.status.name},
          ),
        );
        unawaited(_crashlytics.recordError(result.error, null));
        break;
      case RegistrationResultStatus.fail:
        unawaited(
          _analytics.logEvent(
            eventName: AnalyticsEvent.registrationFailed,
            parameters: {...defaultParams, 'status': result.status.name},
          ),
        );
        unawaited(_crashlytics.recordError(result.error, null));
        break;
    }
  }
}
