import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/analytics.dart';
import 'package:virtualpilgrimage/application/auth/sign_in_usecase.dart';
import 'package:virtualpilgrimage/domain/exception/sign_in_exception.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_crashlytics_provider.dart';
import 'package:virtualpilgrimage/logger.dart';
import 'package:virtualpilgrimage/router.dart';
import 'package:virtualpilgrimage/ui/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/ui/pages/sign_in/sign_in_state.codegen.dart';

final signInPresenterProvider = StateNotifierProvider.autoDispose<SignInPresenter, SignInState>(
  SignInPresenter.new,
);

typedef SignInWithOAuthFunction = Future<VirtualPilgrimageUser> Function();

class SignInPresenter extends StateNotifier<SignInState> {
  SignInPresenter(
    this._ref,
  ) : super(
          SignInState(
            context: SignInStateContext.notSignedIn,
            emailOrNickname: FormModel.of(requiredValidator),
            password: FormModel.of(passwordValidator),
          ),
        ) {
    _signInUsecase = _ref.read(signInUsecaseProvider);
    _userState = _ref.watch(userStateProvider.notifier);
    _loginState = _ref.watch(loginStateProvider.notifier);
    _analytics = _ref.read(analyticsProvider);
    _crashlytics = _ref.read(firebaseCrashlyticsProvider);
  }

  final Ref _ref;
  late final SignInUsecase _signInUsecase;
  late final StateController<VirtualPilgrimageUser?> _userState;
  late final StateController<UserStatus?> _loginState;
  late final Analytics _analytics;
  late final FirebaseCrashlytics _crashlytics;

  void onChangeEmail(FormModel emailOrNickname) =>
      state = state.onChangeEmailOrNickname(emailOrNickname);

  void onChangePassword(FormModel password) => state = state.onChangePassword(password);

  /// Google認証
  Future<void> signInWithGoogle() async {
    await _signInWithOAuthProvider(
      _signInUsecase.signInWithGoogle,
      AnalyticsEvent.signInWithGoogle,
      AnalyticsEvent.signInWithGoogleFailed,
    );
  }

  /// AppleID認証
  Future<void> signInWithApple() async {
    await _signInWithOAuthProvider(
      _signInUsecase.signInWithApple,
      AnalyticsEvent.signInWithApple,
      AnalyticsEvent.signInWithAppleFailed,
    );
  }

  /// OAuth Provider を利用したサインインを行う
  ///
  /// [f] UseCaseに実装しているSignInメソッド
  /// [signInEventName] GoogleAnalytics に記録するイベント名
  /// [exceptionEventName] 例外が発生した時に GoogleAnalytics に記録するイベント名
  Future<void> _signInWithOAuthProvider(
    SignInWithOAuthFunction f,
    String signInEventName,
    String exceptionEventName,
  ) async {
    unawaited(_analytics.logEvent(eventName: signInEventName));
    try {
      final user = await f();
      state = SignInState(
        context: _getSignInContext(user),
        emailOrNickname: state.emailOrNickname,
        password: state.password,
      );
      unawaited(_analytics.setUserProperties(user: user));
      _updateState(user, user.userStatus);
    } on Exception catch (e) {
      _ref.read(loggerProvider).e(e);
      unawaited(_analytics.logEvent(eventName: exceptionEventName, parameters: {'error': e}));
      unawaited(_crashlytics.recordError(e, null));
    }
  }

  /// Email And Password 認証
  Future<void> signInWithEmailAndPassword() async {
    final defaultParams = {
      'email': state.emailOrNickname.text,
      'passwordLength': state.password.text.length
    };
    await _analytics.logEvent(
      eventName: AnalyticsEvent.signInWithEmailAndPassword,
      parameters: defaultParams,
    );
    state = state.onSubmit();
    // バリデーションエラーにかかっている場合はリクエストを送らない
    if (!state.isValidAll()) {
      unawaited(
        _analytics.logEvent(
          eventName: AnalyticsEvent.signInWithEmailAndPasswordFailed,
          parameters: {
            ...defaultParams,
            'emailValidationError': state.emailOrNickname.displayError,
            'passwordValidationError': state.password.displayError,
          },
        ),
      );
      return;
    }

    try {
      late final VirtualPilgrimageUser user;
      if (emailValidator(state.emailOrNickname.text) != null) {
        // null じゃないときメールアドレス形式でない ≒ ニックネームのはずなので、ニックネームで検索
        user = await _signInUsecase.signInWithNicknameAndPassword(
          state.emailOrNickname.text,
          state.password.text,
        );
      } else {
        // email validation で null だった場合はメールアドレスの形式を満たしているので、ユーザ情報が存在するか確認
        user = await _signInUsecase.signInWithEmailAndPassword(
          state.emailOrNickname.text,
          state.password.text,
        );
      }
      state = state.setContext(_getSignInContext(user));
      unawaited(_analytics.setUserProperties(user: user));
      _updateState(user, user.userStatus);
    } on SignInException catch (e) {
      switch (e.status) {
        case SignInExceptionStatus.credentialIsNull:
        case SignInExceptionStatus.credentialUserIsNull:
          state = state.setExternalErrors(
            emailOrNicknameError: '認証情報が空でした。認証に利用するメールアドレスを見直してください',
          );
          break;
        case SignInExceptionStatus.emailOrPasswordIsNull:
          // 設定しているもののvalidationで弾かれるため、ここには分岐しないはず
          const errorMsg = 'メールアドレス・ニックネームまたはパスワードを入力してください';
          state = state.setExternalErrors(emailOrNicknameError: errorMsg, passwordError: errorMsg);
          break;
        case SignInExceptionStatus.firebaseException:
        case SignInExceptionStatus.unknownException:
          const errorMsg = 'サインイン時に想定外のエラーが発生しました';
          state = state.setExternalErrors(emailOrNicknameError: errorMsg, passwordError: errorMsg);
          break;
        case SignInExceptionStatus.platformException:
          const errorMsg = 'お使いの端末のバージョンではアプリを利用できない可能性があります';
          state = state.setExternalErrors(emailOrNicknameError: errorMsg, passwordError: errorMsg);
          break;
        case SignInExceptionStatus.wrongPassword:
          const errorMsg = 'メールアドレス・ニックネームまたはパスワードが誤っています';
          state = state.setExternalErrors(emailOrNicknameError: errorMsg, passwordError: errorMsg);
          break;
        case SignInExceptionStatus.weakPassword:
          // バリデーション側で弾いているため、ここには遷移しないはず
          state = state.setExternalErrors(passwordError: '半角英数字8文字以上で入力してください');
          break;
        case SignInExceptionStatus.alreadyUsedEmail:
          state = state.setExternalErrors(emailOrNicknameError: 'そのメールアドレスは既に利用されています');
          break;
        case SignInExceptionStatus.userNotFoundException:
          state = state.setExternalErrors(
            emailOrNicknameError: 'そのユーザは存在しません。新規アカウント作成時はメールアドレスで認証してください',
          );
          break;
      }
      unawaited(
        _analytics.logEvent(
          eventName: AnalyticsEvent.signInWithEmailAndPasswordFailed,
          parameters: {'error': e, 'validationStatus': e.status.name},
        ),
      );
      unawaited(_crashlytics.recordError(e, null));
    } on Exception catch (e) {
      unawaited(
        _analytics.logEvent(
          eventName: AnalyticsEvent.signInWithEmailAndPasswordFailed,
          parameters: {'error': e},
        ),
      );
      unawaited(_crashlytics.recordError(e, null));
    }
  }

  SignInStateContext _getSignInContext(VirtualPilgrimageUser user) {
    switch (user.userStatus) {
      case UserStatus.temporary:
        return SignInStateContext.temporary;
      case UserStatus.created:
        return SignInStateContext.success;
      case UserStatus.deleted:
        return SignInStateContext.failed;
    }
  }

  /// パスワードリセットページに遷移
  void movePasswordResetPage() {
    _ref.read(routerProvider).push(RouterPath.resetPassword);
  }

  void _updateState(VirtualPilgrimageUser? user, UserStatus? loginStatus) {
    _userState.state = user;
    // loginState を変更するとページが遷移するので更新順を後ろにしている
    _loginState.state = loginStatus;
  }
}
