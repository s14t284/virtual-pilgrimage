import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/application/auth/auth_repository.dart';
import 'package:virtualpilgrimage/application/auth/sign_in_interactor.dart';
import 'package:virtualpilgrimage/application/user/user_repository.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_auth_provider.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_crashlytics_provider.dart';
import 'package:virtualpilgrimage/logger.dart';

final signInUsecaseProvider = Provider.autoDispose<SignInUsecase>(
  (ref) => SignInInteractor(
    ref.read(emailAndPasswordAuthRepositoryProvider),
    ref.read(googleAuthRepositoryProvider),
    ref.read(appleAuthRepositoryProvider),
    ref.read(userRepositoryProvider),
    ref.read(loggerProvider),
    ref.read(firebaseCrashlyticsProvider),
    ref.read(firebaseAuthProvider),
  ),
);

abstract class SignInUsecase {
  Future<VirtualPilgrimageUser> signInWithGoogle();

  Future<VirtualPilgrimageUser> signInWithApple();

  Future<VirtualPilgrimageUser> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<VirtualPilgrimageUser> signInWithNicknameAndPassword(
    String nickname,
    String password,
  );

  Future<void> logout();
}
