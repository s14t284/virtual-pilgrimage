import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:virtualpilgrimage/application/auth/auth_repository.dart';
import 'package:virtualpilgrimage/domain/exception/sign_in_exception.dart';

class AppleAuthRepository extends AuthRepository {
  AppleAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    try {
      // MEMO: getAppleIDCredential は static method なので、DI で SignInWithApple クラスを埋め込むことができない
      // -> unit test ができない
      final appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: AppleIDAuthorizationScopes.values);
      final oAuthCredential = AppleAuthProvider.credential(appleCredential.authorizationCode);
      return _firebaseAuth.signInWithCredential(oAuthCredential);
    } on SignInWithAppleException catch (e) {
      throw SignInException(
        message: 'cause apple sign-in exception [exception][$e]',
        status: SignInExceptionStatus.platformException,
        cause: e,
      );
    } on PlatformException catch (e) {
      throw SignInException(
        message: 'cause platform exception [code][${e.code}][message][${e.message}]',
        status: SignInExceptionStatus.platformException,
        cause: e,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credentials') {
        throw SignInException(
          message:
              'Firebase Account exists with different [message][${e.message}][email][${e.email}]',
          status: SignInExceptionStatus.firebaseException,
          cause: e,
        );
      } else if (e.code == 'invalid-credential') {
        throw SignInException(
          message:
              'Firebase signin is invalid credential [message][${e.message}][email][${e.email}]',
          status: SignInExceptionStatus.firebaseException,
          cause: e,
        );
      }
      throw SignInException(
        message: 'cause Firebase exception when signIn [message][${e.message}][code][${e.code}]',
        status: SignInExceptionStatus.firebaseException,
        cause: e,
      );
    } on Exception catch (e) {
      throw SignInException(
        message: 'Firebase signin cause unknown error [exception][$e]',
        status: SignInExceptionStatus.unknownException,
        cause: e,
      );
    }
  }

  @override
  Future<void> resetPassword({required String email, required String packageName}) {
    // Google認証はパスワードのリセットは必要ないため呼び出されたら例外
    throw UnimplementedError();
  }
}
