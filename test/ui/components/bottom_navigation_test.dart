import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtualpilgrimage/domain/customizable_date_time.dart';
import 'package:virtualpilgrimage/domain/pilgrimage/pilgrimage_info.codegen.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/ui/components/bottom_navigation.dart';

import '../../helper/provider_container.dart';

void main() {
  group('BottomNavigation', () {
    const key = Key('key');
    testWidgets('表示できる', (widgetTester) async {
      await widgetTester
          .pumpWidget(_wrapMaterialApp(mockedProviderScope(const BottomNavigation(key: key))));
      expect(find.byKey(key), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
      expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);
      expect(find.byTooltip('home'), findsOneWidget);
      expect(find.byTooltip('profile'), findsOneWidget);
    });

    setUp(() {});

    testWidgets('タップしてPageTypeのstateが変更される', (widgetTester) async {
      /// PageTypeのstateが更新されると参照しているindexも変わり描画も変更される

      // given
      final loginUser = VirtualPilgrimageUser(
        id: 'dummyLoginUserId',
        birthDay: CustomizableDateTime.current,
        createdAt: CustomizableDateTime.current,
        updatedAt: CustomizableDateTime.current,
        pilgrimage: PilgrimageInfo(updatedAt: CustomizableDateTime.current, id: ''),
      );
      final widget = mockedProviderScope(const BottomNavigation(key: key));

      // when
      await widgetTester.pumpWidget(_wrapMaterialApp(widget));
      // stateの参照のため、parentを利用。nullならテストを落とす
      final parent = widget.parent;
      if (parent == null) {
        throw Exception('initialize widget error. widget.parent is null');
      }
      parent.read(userStateProvider.notifier).state = loginUser;

      // then
      expect(parent.read(pageTypeProvider).index, 2);
      // プロフィールアイコンをタップするとstateが更新
      await widgetTester.tap(find.byIcon(Icons.account_circle_outlined));
      expect(parent.read(pageTypeProvider).index, 3);
      // マップアイコンをタップするとstateが元に戻る
      await widgetTester.tap(find.byIcon(Icons.map_outlined));
      expect(parent.read(pageTypeProvider).index, 2);
    });
  });
}

Widget _wrapMaterialApp(Widget bottomBar) {
  return MaterialApp(
    home: Scaffold(
      bottomNavigationBar: bottomBar,
    ),
  );
}
