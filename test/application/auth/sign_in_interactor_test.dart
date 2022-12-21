import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:virtualpilgrimage/application/auth/sign_in_interactor.dart';
import 'package:virtualpilgrimage/application/auth/sign_in_usecase.dart';
import 'package:virtualpilgrimage/domain/customizable_date_time.dart';
import 'package:virtualpilgrimage/domain/exception/database_exception.dart';
import 'package:virtualpilgrimage/domain/exception/sign_in_exception.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/pilgrimage_info.codegen.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';

import '../../helper/default_mock_firebase_crashlytics.dart';
import '../../helper/mock.mocks.dart';
import '../../helper/provider_container.dart';

void main() {
  late MockEmailAndPasswordAuthRepository mockEmailAndPasswordAuthRepository;
  late MockGoogleAuthRepository mockGoogleAuthRepository;
  late MockAppleAuthRepository mockAppleAuthRepository;
  late MockUserRepository mockUserRepository;
  late MockFirebaseCrashlytics mockFirebaseCrashlytics;
  late MockFirebaseAuth mockFirebaseAuth;
  final logger = Logger(level: Level.nothing);

  late SignInInteractor target;

  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  const userId = 'dummyId';

  setUp(() {
    mockEmailAndPasswordAuthRepository = MockEmailAndPasswordAuthRepository();
    mockGoogleAuthRepository = MockGoogleAuthRepository();
    mockAppleAuthRepository = MockAppleAuthRepository();
    mockUserRepository = MockUserRepository();
    mockFirebaseCrashlytics = MockFirebaseCrashlytics();
    mockFirebaseAuth = MockFirebaseAuth();
    target = SignInInteractor(
      mockEmailAndPasswordAuthRepository,
      mockGoogleAuthRepository,
      mockAppleAuthRepository,
      mockUserRepository,
      logger,
      mockFirebaseCrashlytics,
      mockFirebaseAuth,
    );
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  group('SignInInteractor', () {
    CustomizableDateTime.customTime = DateTime.now();

    test('DI', () {
      final container = mockedProviderContainer();
      final usecase = container.read(signInUsecaseProvider);
      expect(usecase, isNotNull);
    });

    group('signInWithGoogle', () {
      setUp(() {
        const email = 'test@example.com';
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn('dummyName');
        when(mockUser.photoURL).thenReturn('http://example.com');
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockGoogleAuthRepository.signIn()).thenAnswer((_) => Future.value(mockUserCredential));
        defaultMockSignInWithCredentialUser(
          mockUserRepository,
          mockFirebaseCrashlytics,
          userId: userId,
          email: email,
        );
      });
      group('正常系', () {
        test('ユーザが既に存在し、サインインできる', () async {
          // given
          final expected = defaultUser(id: userId);

          // when
          final actual = await target.signInWithGoogle();

          // then
          expect(actual, expected);
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verify(mockFirebaseCrashlytics.setUserIdentifier(userId)).called(1);
          verify(mockUserRepository.get(userId)).called(1);
          verifyNever(mockUserRepository.update(any)).called(0); // ユーザが存在していたので更新は実行されない
        });

        test('ユーザが存在しないため、作成してサインインできる', () async {
          // given
          when(mockUserRepository.get(userId)).thenAnswer((_) => Future.value(null));

          final expected = defaultUser(id: userId).copyWith(
            nickname: '',
            birthDay: DateTime.utc(1980, 1, 1),
            userIconUrl: 'http://example.com',
            userStatus: UserStatus.temporary,
          );

          // when
          final actual = await target.signInWithGoogle();

          // then
          expect(actual, expected);
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verify(mockFirebaseCrashlytics.setUserIdentifier(userId)).called(1);
          verify(mockUserRepository.get(userId)).called(1);
          verify(mockUserRepository.update(expected)).called(1); // ユーザが存在していなかったので更新を実行
          // 一旦、ピン画像は更新しないようにしている
          // verify(mockUserIconRepository.loadIconImage('http://example.com')).called(1);
        });
      });

      group('異常系', () {
        test('Credential が空', () async {
          // given
          when(mockGoogleAuthRepository.signIn()).thenAnswer((_) => Future.value(null));

          // when, then
          expect(
            () => target.signInWithGoogle(),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verifyNever(mockUserRepository.get(any)).called(0);
        });

        test('ユーザ情報取得時に例外', () async {
          // given
          when(mockUserRepository.get(userId)).thenThrow(const DatabaseException(message: 'dummy'));

          // when, then
          expect(
            () => target.signInWithGoogle(),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verifyNever(mockUserRepository.get(any)).called(0);
          verifyNever(mockUserRepository.update(any)).called(0);
        });

        test('ユーザ情報更新時に例外', () async {
          // given
          when(mockUserRepository.get(userId)).thenAnswer((_) => Future.value(null));

          when(mockUserRepository.update(any)).thenThrow(
            DatabaseException(
              message: 'dummy',
              cause: FirebaseException(plugin: 'dummy', stackTrace: StackTrace.current),
            ),
          );

          // when, then
          expect(
            () => target.signInWithGoogle(),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verifyNever(mockUserRepository.get(any)).called(0);
          verifyNever(mockUserRepository.update(any)).called(0);
        });

        test('ユーザ情報更新時に未知の例外', () async {
          // given
          when(mockUserRepository.get(userId)).thenAnswer((_) => Future.value(null));

          /// 条件網羅のため、DatabaseException ではなく、Exception にしている
          when(mockUserRepository.update(any)).thenThrow(Exception('dummy'));

          // when, then
          expect(
            () => target.signInWithGoogle(),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockGoogleAuthRepository.signIn()).called(1);
          verifyNever(mockUserRepository.get(any)).called(0);
          verifyNever(mockUserRepository.update(any)).called(0);
        });
      });
    });

    // signInWithGoogle のテストで signInWithCredentialUser のテストが担保できているため
    // こちらでのテストは最低限とする
    group('signInWithEmailAndPassword', () {
      const email = 'test@example.com';
      const password = 'Passw0rd123';
      group('正常系', () {
        setUp(() {
          defaultMockSignInWithEmailAndPassword(
            mockEmailAndPasswordAuthRepository,
            mockUserRepository,
            mockFirebaseCrashlytics,
            mockUserCredential,
            mockUser,
            userId: userId,
            email: email,
            password: password,
          );
        });

        test('ユーザが既に存在し、サインインできる', () async {
          // given
          final expected = defaultUser(id: userId);

          // when
          final actual = await target.signInWithEmailAndPassword(email, password);

          // then
          expect(actual, expected);
          verify(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .called(1);
          verify(mockFirebaseCrashlytics.setUserIdentifier(userId)).called(1);
          verify(mockUserRepository.get(userId)).called(1);
          verifyNever(mockUserRepository.update(any)).called(0); // ユーザが存在していたので更新は実行されない
        });
      });

      group('異常系', () {
        test('Credential が空', () async {
          // given
          when(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .thenAnswer((_) => Future.value(null));

          // when, then
          expect(
            () => target.signInWithEmailAndPassword(email, password),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .called(1);
          verifyNever(mockUserRepository.get(any)).called(0);
        });
      });
    });

    // signInWithGoogle のテストで signInWithCredentialUser のテストが担保できているため
    // こちらでのテストは最低限とする
    group('signInWithNicknameAndPassword', () {
      const nickname = 'dummy00';
      const email = 'test@example.com';
      const password = 'Passw0rd123';
      group('正常系', () {
        setUp(() {
          defaultMockSignInWithEmailAndPassword(
            mockEmailAndPasswordAuthRepository,
            mockUserRepository,
            mockFirebaseCrashlytics,
            mockUserCredential,
            mockUser,
            userId: userId,
            email: email,
            nickname: nickname,
            password: password,
          );
        });

        test('ユーザが既に存在し、サインインできる', () async {
          // given
          final expected = defaultUser(id: userId, nickname: nickname, email: email);
          when(mockUserRepository.findWithNickname(nickname)).thenAnswer(
            (_) => Future.value(
              expected,
            ),
          );

          // when
          final actual = await target.signInWithNicknameAndPassword(nickname, password);

          // then
          expect(actual, expected);
          verify(mockUserRepository.findWithNickname(nickname)).called(1);
          verify(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .called(1);
          verify(mockFirebaseCrashlytics.setUserIdentifier(userId)).called(1);
          verify(mockUserRepository.get(userId)).called(1);
          verifyNever(mockUserRepository.update(any)).called(0); // ユーザが存在していたので更新は実行されない
        });
      });

      group('異常系', () {
        test('指定したニックネームのユーザが存在しない', () async {
          // given
          when(mockUserRepository.findWithNickname(any)).thenAnswer((_) => Future.value(null));

          // when, then
          expect(
            () => target.signInWithNicknameAndPassword(nickname, password),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockUserRepository.findWithNickname(any)).called(1);
          verifyNever(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .called(0);
        });

        test('ニックネームを使った検索時にDBへの問い合わせに失敗', () async {
          // given
          when(mockUserRepository.findWithNickname(any)).thenThrow(
            DatabaseException(
              message: 'dummy',
              cause: FirebaseException(plugin: 'dummy', stackTrace: StackTrace.current),
            ),
          );

          // when, then
          expect(
            () => target.signInWithNicknameAndPassword(nickname, password),
            throwsA(const TypeMatcher<SignInException>()),
          );
          verify(mockUserRepository.findWithNickname(any)).called(1);
          verifyNever(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
              .called(0);
        });
      });
    });

    group('logout', () {
      test('正常系', () async {
        // given
        when(mockFirebaseAuth.signOut()).thenAnswer((_) => Future.value());

        // when
        await target.logout();

        // then
        verify(mockFirebaseAuth.signOut()).called(1);
      });
    });
  });
}

void defaultMockSignInWithCredentialUser(
  MockUserRepository mockUserRepository,
  MockFirebaseCrashlytics mockFirebaseCrashlytics, {
  String userId = 'dummyId',
  String email = 'test@example.com',
  String nickname = 'dummyName',
}) {
  when(mockUserRepository.get(userId)).thenAnswer(
    (_) => Future.value(
      defaultUser(
        id: userId,
        email: email,
        nickname: nickname,
      ),
    ),
  );
  when(mockUserRepository.update(any)).thenAnswer((_) => Future.value());
  defaultMockFirebaseCrashlytics(mockFirebaseCrashlytics);
}

void defaultMockSignInWithEmailAndPassword(
  MockEmailAndPasswordAuthRepository mockEmailAndPasswordAuthRepository,
  MockUserRepository mockUserRepository,
  MockFirebaseCrashlytics mockFirebaseCrashlytics,
  MockUserCredential mockUserCredential,
  MockUser mockUser, {
  String userId = 'dummyId',
  String email = 'test@example.com',
  String nickname = 'dummyName',
  String password = 'Passw0rd123',
}) {
  when(mockUser.uid).thenReturn(userId);
  when(mockUser.email).thenReturn(email);
  when(mockUser.displayName).thenReturn('dummyName');
  when(mockUser.photoURL).thenReturn('http://example.com');
  when(mockUserCredential.user).thenReturn(mockUser);
  when(mockEmailAndPasswordAuthRepository.signIn(email: email, password: password))
      .thenAnswer((_) => Future.value(mockUserCredential));
  defaultMockSignInWithCredentialUser(
    mockUserRepository,
    mockFirebaseCrashlytics,
    userId: userId,
    email: email,
    nickname: nickname,
  );
}

VirtualPilgrimageUser defaultUser({
  String id = 'dummyId',
  String nickname = 'dummyName',
  String email = 'test@example.com',
}) {
  return VirtualPilgrimageUser(
    id: id,
    nickname: nickname,
    birthDay: DateTime.utc(2000),
    email: email,
    userIconUrl: '',
    userStatus: UserStatus.created,
    createdAt: CustomizableDateTime.current,
    updatedAt: CustomizableDateTime.current,
    pilgrimage: PilgrimageInfo(id: id, updatedAt: CustomizableDateTime.current),
  );
}
