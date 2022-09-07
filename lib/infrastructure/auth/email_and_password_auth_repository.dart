import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:virtualpilgrimage/domain/auth/auth_repository.dart';
import 'package:virtualpilgrimage/domain/exception/sign_in_exception.dart';

// ref. https://firebase.google.com/docs/auth/flutter/password-auth
class EmailAndPasswordRepository extends AuthRepository {
  EmailAndPasswordRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    // interface 定義の都合上 email, password が nullable だが、
    // email, password が必要なので、null だったら例外
    if (email == null || password == null) {
      throw SignInException(
        'email or password are null [email][$email][password][$password]',
        SignInExceptionStatus.emailOrPasswordIsNull,
      );
    }

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on PlatformException catch (e) {
      throw SignInException(
        'cause platform exception [code][${e.code}][message][${e.message}]',
        SignInExceptionStatus.platformException,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return _signInWithCreateUser(email, password);
      } else if (e.code == 'wrong-password') {
        throw SignInException(
          'Firebase exception because user set wrong password'
          '[message][${e.message}]'
          '[email][${e.email}]',
          SignInExceptionStatus.wrongPassword,
        );
      }
      throw SignInException(
        'cause Firebase exception when signIn'
        '[message][${e.message}]'
        '[code][${e.code}]',
        SignInExceptionStatus.firebaseException,
      );
    } on Exception catch (e) {
      throw SignInException(
        'Firebase signin cause unknown error [exception][$e]',
        SignInExceptionStatus.unknownException,
      );
    }
  }

  FutureOr<UserCredential?> _signInWithCreateUser(
    String email,
    String password,
  ) async {
    try {
      return _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw SignInException(
          'password set with user is weak'
          '[message][${e.message}]'
          '[email][${e.email}]',
          SignInExceptionStatus.weakPassword,
        );
      } else if (e.code == 'email-already-in-use') {
        throw SignInException(
          'email already in use [message][${e.message}][email][${e.email}]',
          SignInExceptionStatus.alreadyUsedEmail,
        );
      }
      throw SignInException(
        'Firebase signin with create user cause unknown error',
        SignInExceptionStatus.firebaseException,
      );
    } on Exception catch (e) {
      throw SignInException(
        'Firebase signin cause unknown error [exception][$e]',
        SignInExceptionStatus.unknownException,
      );
    }
  }
}
