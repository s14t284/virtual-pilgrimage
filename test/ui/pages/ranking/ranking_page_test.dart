import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:virtualpilgrimage/application/ranking/ranking_repository.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_by_period.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_user.codegen.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/ranking_page.dart';

import '../../../helper/mock.mocks.dart';
import '../../../helper/provider_container.dart';
import '../../../helper/wrap_material_app.dart';

void main() {
  // 2022-12-31 16:02:55:000
  const updatedTime = 1672470175000;

  final List<RankingUser> dailyRankingUserList = createRankingUserList(10);
  final List<RankingUser> weeklyRankingUserList = createRankingUserList(20);
  final List<RankingUser> monthlyRankingUserList = createRankingUserList(30);
  final mockRanking = Ranking(
    daily: RankingByPeriod(
      step: RankingUsers(users: dailyRankingUserList),
      distance: RankingUsers(users: dailyRankingUserList),
      updatedTime: updatedTime,
    ),
    weekly: RankingByPeriod(
      step: RankingUsers(users: weeklyRankingUserList),
      distance: RankingUsers(users: weeklyRankingUserList),
      updatedTime: updatedTime,
    ),
    monthly: RankingByPeriod(
      step: RankingUsers(users: monthlyRankingUserList),
      distance: RankingUsers(users: monthlyRankingUserList),
      updatedTime: updatedTime,
    ),
  );

  final rankingRepository = MockRankingRepository();
  when(rankingRepository.get()).thenAnswer((_) => Future.value(mockRanking));

  // ダイアログの表示テストはwidgetテストの範囲に収まらないので、実装していない
  group('RankingPage', () {
    final overrideRankingRepository =
        rankingRepositoryProvider.overrideWithValue(rankingRepository);
    testWidgets('表示できる', (widgetTester) async {
      // MEMO: mockNetworkImagesFor: Network通信をmock化してテスト
      await mockNetworkImagesFor(
        () => widgetTester.pumpWidget(
          wrapMaterialApp(
            mockedProviderScope(
              const RankingPage(),
              overrides: [overrideRankingRepository],
            ),
          ),
        ),
      );

      await mockNetworkImagesFor(() => widgetTester.pump());

      expect(find.text('1 位'), findsOneWidget);
      expect(find.text('2 位'), findsOneWidget);
      expect(find.text('dummyName3'), findsOneWidget);
      expect(find.text('5000 歩'), findsOneWidget);
      // デフォルトで表示されている情報
      expect(find.text('最終更新日: 2022/12/31 (毎日4時頃更新予定)'), findsOneWidget);
      for (final kind in ['歩数', '距離']) {
        expect(find.text(kind), findsOneWidget);
      }
      for (final period in ['昨日', '週間', '月間']) {
        expect(find.text(period), findsOneWidget);
      }
    });

    testWidgets('スクロールするとランキングの続きが表示される', (widgetTester) async {
      await mockNetworkImagesFor(
        () => widgetTester.pumpWidget(
          wrapMaterialApp(
            mockedProviderScope(const RankingPage(), overrides: [overrideRankingRepository]),
          ),
        ),
      );
      await mockNetworkImagesFor(() => widgetTester.pump());

      // ref. https://docs.flutter.dev/cookbook/testing/widget/scrolling
      final listFinder = find.byType(Scrollable).first;
      final itemFinder = find.byKey(const ValueKey('ranking_9'));

      await widgetTester.scrollUntilVisible(itemFinder, 500, scrollable: listFinder);
      await mockNetworkImagesFor(() => widgetTester.pump());

      // 末尾のランキングが見えているはず
      expect(itemFinder, findsOneWidget);
      // 期待する情報が見えているか検証
      expect(find.text('10 位'), findsOneWidget);
      expect(find.text('9 位'), findsOneWidget);
      // 5位の名前
      expect(find.text('dummyName5'), findsOneWidget);
      // 10位の歩数
      expect(find.text('1000 歩'), findsOneWidget);
    });

    testWidgets('タブをタップすると表示するランキングの期間・種類を変更できる', (widgetTester) async {
      await mockNetworkImagesFor(
        () => widgetTester.pumpWidget(
          wrapMaterialApp(
            mockedProviderScope(
              const RankingPage(),
              overrides: [rankingRepositoryProvider.overrideWithValue(rankingRepository)],
            ),
          ),
        ),
      );
      await mockNetworkImagesFor(() => widgetTester.pump());

      // 初期状態で表示されている情報を確認
      expect(find.text('10000 歩'), findsOneWidget);

      // 期間「週間」タブをタップ
      await widgetTester.tap(find.text('週間'));
      await mockNetworkImagesFor(() => widgetTester.pumpAndSettle());

      // 1位の情報が変化していることを確認
      expect(find.text('1 位'), findsOneWidget);
      expect(find.text('dummyName1'), findsOneWidget);
      expect(find.text('20000 歩'), findsOneWidget);

      // 種類「距離」タブをタップ
      await widgetTester.tap(find.text('距離'));
      await mockNetworkImagesFor(() => widgetTester.pumpAndSettle());

      // 3位の情報が距離になっていることを確認
      expect(find.text('3 位'), findsOneWidget);
      expect(find.text('18.00 km'), findsOneWidget);

      // スクロールしてみる
      // ref. https://docs.flutter.dev/cookbook/testing/widget/scrolling
      final listFinder = find.byType(Scrollable).first;
      final itemFinder = find.byKey(const ValueKey('ranking_20'));
      await widgetTester.scrollUntilVisible(itemFinder, 500, scrollable: listFinder);

      // 末尾のランキングが見えているはず
      expect(itemFinder, findsOneWidget);
      // 期待する情報が見えているか検証
      expect(find.text('19 位'), findsOneWidget);
      // 20位の情報を表示
      expect(find.text('20 位'), findsOneWidget);
      expect(find.text('dummyName20'), findsOneWidget);
      expect(find.text('1.00 km'), findsOneWidget);

      // 期間「月間」タブをタップ
      await widgetTester.tap(find.text('月間'));
      await mockNetworkImagesFor(() => widgetTester.pumpAndSettle());
      // 1位の情報が変化していることを確認
      // スクロールがリセットされていることも確認
      expect(find.text('1 位'), findsOneWidget);
      expect(find.text('dummyName1'), findsOneWidget);
      expect(find.text('30.00 km'), findsOneWidget);
    });
  });
}

List<RankingUser> createRankingUserList(int userLength) {
  final List<RankingUser> users = [];
  for (int i = 0; i < userLength; i++) {
    users.add(
      RankingUser(
        userId: 'dummyId${i + 1}',
        nickname: 'dummyName${i + 1}',
        userIconUrl: 'http://example.com/icon.jpg',
        value: (userLength - i) * 1000,
        rank: i + 1,
      ),
    );
  }
  return users;
}
