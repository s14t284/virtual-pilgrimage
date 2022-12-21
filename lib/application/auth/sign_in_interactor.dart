import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:virtualpilgrimage/application/auth/auth_repository.dart';
import 'package:virtualpilgrimage/application/auth/sign_in_usecase.dart';
import 'package:virtualpilgrimage/application/user/user_repository.dart';
import 'package:virtualpilgrimage/domain/exception/database_exception.dart';
import 'package:virtualpilgrimage/domain/exception/sign_in_exception.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';

enum LoginMethod {
  emailAndPassword,
  google,
  apple,
}

typedef SignInMethodType = Future<UserCredential?> Function({String? email, String? password});

class SignInInteractor extends SignInUsecase {
  SignInInteractor(
    this._emailAndPasswordAuthRepository,
    this._googleAuthRepository,
    this._appleAuthRepository,
    this._userRepository,
    this._logger,
    this._crashlytics,
    this._firebaseAuth,
  );

  final AuthRepository _emailAndPasswordAuthRepository;
  final AuthRepository _googleAuthRepository;
  final AuthRepository _appleAuthRepository;
  final UserRepository _userRepository;
  final Logger _logger;
  final FirebaseCrashlytics _crashlytics;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<VirtualPilgrimageUser> signInWithGoogle() async {
    return _signIn(_googleAuthRepository.signIn, LoginMethod.google);
  }

  @override
  Future<VirtualPilgrimageUser> signInWithApple() async {
    return _signIn(_appleAuthRepository.signIn, LoginMethod.apple);
  }

  @override
  Future<VirtualPilgrimageUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _signIn(
      _emailAndPasswordAuthRepository.signIn,
      LoginMethod.emailAndPassword,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    // TODO(s14t284): firebase を直参照ではなく、もっといい方法を考える
    await _firebaseAuth.signOut();
  }

  Future<VirtualPilgrimageUser> _signIn(
    SignInMethodType f,
    LoginMethod method, {
    String? email,
    String? password,
  }) async {
    final credential = await f(email: email, password: password);
    // Firebase から取得した Credential 情報の null check
    if (credential == null || credential.user == null) {
      final message = 'signin with ${method.name} result is null';
      _logger.e(message);
      await _crashlytics.log(message);
      throw SignInException(message: message, status: SignInExceptionStatus.credentialIsNull);
    }
    final credentialUser = credential.user!;

    await _crashlytics.setUserIdentifier(credentialUser.uid);
    return _signInWithCredentialUser(credentialUser, method);
  }

  Future<VirtualPilgrimageUser> _signInWithCredentialUser(
    User credentialUser,
    LoginMethod loginMethod,
  ) async {
    final signInMessage = 'signin with $loginMethod'
        '[userId][${credentialUser.uid}]'
        '[email][${credentialUser.email ?? ''}]';
    _logger.i(signInMessage);
    await _crashlytics.log(signInMessage);

    // ユーザー情報を作成
    VirtualPilgrimageUser user;
    try {
      final gotUser = await _userRepository.get(credentialUser.uid);
      // ユーザーがまだ作成されていない場合、デフォルト値を埋めてFirestoreに保存
      if (gotUser == null) {
        user = VirtualPilgrimageUser.initializeForSignIn(credentialUser);
        await _userRepository.update(user);
      } else {
        user = gotUser;
      }
    } on DatabaseException catch (e) {
      _logger.e(e.message, [e]);
      await _crashlytics.log(e.message);
      final causeException = e.cause;
      final stackTrace = causeException is FirebaseException ? causeException.stackTrace : null;
      await _crashlytics.recordError(
        e,
        stackTrace,
        reason: 'DatabaseException',
      );

      throw SignInException(
        message: e.message,
        status: SignInExceptionStatus.firebaseException,
        cause: e,
      );
    } on Exception catch (e) {
      final message = 'get user or initialize user is error [uid][${credentialUser.uid}]';
      _logger.e(message, [e]);
      await _crashlytics.log(message);
      await _crashlytics.recordError(
        e,
        null,
        reason: 'Exception',
      );

      throw SignInException(
        message: message,
        status: SignInExceptionStatus.unknownException,
        cause: e,
      );
    }

    return user;
  }

  @override
  Future<VirtualPilgrimageUser> signInWithNicknameAndPassword(
    String nickname,
    String password,
  ) async {
    late final VirtualPilgrimageUser? user;
    try {
      // ログインしていないが先にユーザ情報を検索し、そのニックネームが存在するか確認する
      user = await _userRepository.findWithNickname(nickname);
    } on DatabaseException catch (e) {
      // 初回の検索時の例外ハンドリングだけはこのメソッド内に実装
      _logger.e(e.message, [e]);
      await _crashlytics.log(e.message);
      final causeException = e.cause;
      final stackTrace = causeException is FirebaseException ? causeException.stackTrace : null;
      await _crashlytics.recordError(
        e,
        stackTrace,
        reason: 'DatabaseException',
      );

      throw SignInException(
        message: e.message,
        status: SignInExceptionStatus.firebaseException,
        cause: e,
      );
    }

    if (user == null) {
      throw SignInException(
        message: 'failed to find user for login with nickname and password [nickname][$nickname}]',
        status: SignInExceptionStatus.userNotFoundException,
      );
    }

    // ニックネームが存在している場合、検索時に取得できたメールアドレスを使って認証する
    // 例外処理もこのメソッドの中で実装されているため必要なし
    return signInWithEmailAndPassword(user.email, password);
  }
}
