import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:virtualpilgrimage/application/user/user_repository.dart';
import 'package:virtualpilgrimage/domain/customizable_date_time.dart';
import 'package:virtualpilgrimage/domain/exception/database_exception.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/pilgrimage_info.codegen.dart';
import 'package:virtualpilgrimage/domain/user/deleted_user.codegen.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/user/user_repository_impl.dart';

import '../../helper/mock.mocks.dart';
import '../../helper/mock_query_document_snapshot.dart';
import '../../helper/provider_container.dart';

void main() {
  final logger = Logger(level: Level.error);

  late MockFirebaseFirestore mockFirebaseFirestore;
  late UserRepositoryImpl target;

  late MockDocumentSnapshot<VirtualPilgrimageUser> mockDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<VirtualPilgrimageUser> mockUserDocumentReference;
  late MockDocumentReference<DeletedUser> mockDeletedUserDocumentReference;
  late MockDocumentReference<Map<String, dynamic>> mockMapDocumentReference;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuery<VirtualPilgrimageUser> mockQueryDomainUser;
  late MockQuerySnapshot<VirtualPilgrimageUser> mockQuerySnapshot;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    target = UserRepositoryImpl(
      mockFirebaseFirestore,
      logger,
    );

    mockDocumentSnapshot = MockDocumentSnapshot();
    mockCollectionReference = MockCollectionReference();
    mockUserDocumentReference = MockDocumentReference();
    mockDeletedUserDocumentReference = MockDocumentReference();
    mockMapDocumentReference = MockDocumentReference();
    mockQuery = MockQuery();
    mockQueryDomainUser = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
  });

  group('UserRepositoryImpl', () {
    test('DI', () {
      final container = mockedProviderContainer();
      final repository = container.read(userRepositoryProvider);
      expect(repository, isNotNull);
    });

    group('get', () {
      const userId = 'dummy';
      final expected = defaultUser(userId);
      setUp(() {
        when(mockDocumentSnapshot.data()).thenReturn(expected);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockUserDocumentReference.get(const GetOptions(source: Source.server))).thenAnswer(
          (_) => Future.value(mockDocumentSnapshot),
        );
        when(
          mockMapDocumentReference.withConverter<VirtualPilgrimageUser>(
            fromFirestore: anyNamed('fromFirestore'),
            toFirestore: anyNamed('toFirestore'),
          ),
        ).thenReturn(mockUserDocumentReference);
        when(mockCollectionReference.doc(userId)).thenReturn(mockMapDocumentReference);
        when(mockFirebaseFirestore.collection('users')).thenReturn(mockCollectionReference);
      });

      group('?????????', () {
        test('?????????????????????????????????', () async {
          // when
          final actual = await target.get(userId);

          // then
          expect(actual, expected);
          verify(mockFirebaseFirestore.collection('users')).called(1);
        });

        test('????????????ID??????????????????????????????', () async {
          // given
          when(mockDocumentSnapshot.exists).thenReturn(false);

          // when
          final actual = await target.get(userId);

          // then
          expect(actual, null);
        });
      });

      group('?????????', () {
        final params = {
          'FirebaseException': FirebaseException(plugin: 'dummy'),
          'Exception': Exception(),
        };

        for (final param in params.entries) {
          test('${param.key} ?????????', () async {
            // given
            when(mockFirebaseFirestore.collection('users')).thenThrow(param.value);

            // when
            // repository ?????? DatabaseException ????????????????????????????????????
            expect(
              () => target.get('dummyId'),
              throwsA(const TypeMatcher<DatabaseException>()),
            );
            verify(mockFirebaseFirestore.collection('users')).called(1);
          });
        }
      });
    });

    group('update', () {
      final user = defaultUser();
      setUp(() {
        when(mockFirebaseFirestore.collection('users')).thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(user.id)).thenReturn(mockMapDocumentReference);
        when(mockMapDocumentReference.set(user.toJson())).thenAnswer((_) => Future.value());
      });

      group('?????????', () {
        test('??????????????????????????????????????????', () async {
          // when
          await target.update(user);

          // then
          verify(mockFirebaseFirestore.collection('users')).called(1);
          verify(mockMapDocumentReference.set(user.toJson())).called(1);
        });
      });

      group('?????????', () {
        final params = {
          'FirebaseException': FirebaseException(plugin: 'dummy'),
          'Exception': Exception(),
        };

        for (final param in params.entries) {
          test('${param.key} ?????????', () async {
            // given
            when(mockFirebaseFirestore.collection('users')).thenThrow(param.value);

            // when
            // repository ?????? DatabaseException ????????????????????????????????????
            expect(
              () => target.update(user),
              throwsA(const TypeMatcher<DatabaseException>()),
            );
            verify(mockFirebaseFirestore.collection('users')).called(1);
          });
        }
      });
    });

    group('findWithNickname', () {
      final users = [
        defaultUser('user1', 'name1'),
        defaultUser('user2', 'name2'),
      ];

      group('?????????', () {
        final mockQueryDocumentSnapshots = [
          MockQueryDocumentSnapshot<VirtualPilgrimageUser>(users[0], MockDocumentReference()),
          MockQueryDocumentSnapshot<VirtualPilgrimageUser>(users[1], MockDocumentReference()),
        ];
        setUp(() {
          when(mockQuerySnapshot.docs).thenReturn(mockQueryDocumentSnapshots);
          when(mockQuerySnapshot.size).thenReturn(users.length);
          when(mockQueryDomainUser.get(const GetOptions(source: Source.server))).thenAnswer(
            (_) => Future.value(mockQuerySnapshot),
          );
          when(
            mockQuery.withConverter<VirtualPilgrimageUser>(
              fromFirestore: anyNamed('fromFirestore'),
              toFirestore: anyNamed('toFirestore'),
            ),
          ).thenReturn(mockQueryDomainUser);
          when(mockCollectionReference.where('nickname', isEqualTo: anyNamed('isEqualTo')))
              .thenReturn(mockQuery);
          when(mockFirebaseFirestore.collection('users')).thenReturn(mockCollectionReference);
        });

        test('????????????????????????????????????????????????????????????', () async {
          // when
          final actual = await target.findWithNickname('user1');

          // then
          expect(actual, users[0]);
        });
        test('????????????????????????????????????????????????????????????', () async {
          // given
          when(mockQuerySnapshot.docs).thenReturn([]);
          when(mockQuerySnapshot.size).thenReturn(0);
          when(mockQueryDomainUser.get()).thenAnswer(
            (_) => Future.value(mockQuerySnapshot),
          );
          when(
            mockQuery.withConverter<VirtualPilgrimageUser>(
              fromFirestore: anyNamed('fromFirestore'),
              toFirestore: anyNamed('toFirestore'),
            ),
          ).thenReturn(mockQueryDomainUser);
          when(mockCollectionReference.where('nickname', isEqualTo: 'name1')).thenReturn(mockQuery);
          when(mockFirebaseFirestore.collection('users')).thenReturn(mockCollectionReference);

          // when
          final actual = await target.findWithNickname('user1');

          // then
          expect(actual, null);
        });
      });
    });

    group('delete', () {
      final user = defaultUser();
      final deletedUser = DeletedUser(id: 'dummyId', deletedAt: CustomizableDateTime.current);
      final MockCollectionReference<Map<String, dynamic>> mockDeletedUserCollectionReference =
          MockCollectionReference();
      final MockDocumentReference<Map<String, dynamic>> mockDeletedUserMapDocumentReference =
          MockDocumentReference();
      setUp(() {
        when(mockFirebaseFirestore.runTransaction<void>(any)).thenAnswer((_) => Future.value());
        when(mockFirebaseFirestore.collection('users')).thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(user.id)).thenReturn(mockMapDocumentReference);
        when(mockMapDocumentReference.set(user.toJson())).thenAnswer((_) => Future.value());
        when(mockFirebaseFirestore.collection('deleted_users'))
            .thenReturn(mockDeletedUserCollectionReference);
        when(mockDeletedUserCollectionReference.doc(deletedUser.id))
            .thenReturn(mockDeletedUserMapDocumentReference);
        when(mockDeletedUserMapDocumentReference.set(deletedUser.toJson()))
            .thenAnswer((_) => Future.value());
        when(
          mockDeletedUserMapDocumentReference.withConverter<DeletedUser>(
            fromFirestore: anyNamed('fromFirestore'),
            toFirestore: anyNamed('toFirestore'),
          ),
        ).thenReturn(mockDeletedUserDocumentReference);
      });

      group('?????????', () {
        test('???????????????????????????????????????', () async {
          // when
          await target.delete(user);

          // then
          verify(mockFirebaseFirestore.collection('users')).called(1);
          verify(mockFirebaseFirestore.collection('deleted_users')).called(1);
          verify(mockFirebaseFirestore.runTransaction<void>(any)).called(1);
        });
      });
    });
  });
}

VirtualPilgrimageUser defaultUser([
  String userId = 'dummyId',
  String nickname = 'dummyName',
]) {
  return VirtualPilgrimageUser(
    id: userId,
    nickname: nickname,
    email: 'test@example.com',
    birthDay: DateTime.utc(2000),
    userStatus: UserStatus.created,
    createdAt: CustomizableDateTime.current,
    updatedAt: CustomizableDateTime.current,
    pilgrimage: PilgrimageInfo(id: userId, updatedAt: CustomizableDateTime.current),
  );
}
