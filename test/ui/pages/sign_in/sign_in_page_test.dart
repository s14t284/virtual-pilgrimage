import 'package:flutter_test/flutter_test.dart';
import 'package:virtualpilgrimage/ui/pages/sign_in/sign_in_page.dart';

import '../../../helper/provider_container.dart';
import '../../../helper/wrap_material_app.dart';

void main() {
  group('SignInPage', () {
    testWidgets('表示できる', (widgetTester) async {
      await widgetTester.pumpWidget(
        wrapMaterialApp(mockedProviderScope(const SignInPage())),
      );
      expect(find.text('メールアドレス or ニックネーム'), findsOneWidget);
      expect(find.text('パスワード'), findsOneWidget);
      expect(find.text('サインイン・新規アカウント作成'), findsOneWidget);
      expect(find.text('パスワードを忘れた場合'), findsOneWidget);
      expect(find.text('Google でサインイン'), findsOneWidget);
    });
  });
}
