import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/router.dart';

final pageTypeProvider = StateProvider<PageType>((_) => PageType.home);

enum PageType {
  home,
  profile,
  // ranking,
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(this._ref, {super.key});

  final WidgetRef _ref;

  @override
  Widget build(BuildContext context) {
    final userState = _ref.watch(userStateProvider);
    final pageType = _ref.watch(pageTypeProvider);
    final pageTypeNotifier = _ref.read(pageTypeProvider.notifier);
    final router = _ref.read(routerProvider);

    final destinations = <Widget>[
      NavigationDestination(
        icon: const Icon(Icons.map_rounded),
        label: PageType.home.name,
      ),
      NavigationDestination(
        icon: const Icon(Icons.account_circle),
        label: PageType.profile.name,
      ),
      // 下記はランキングページ用の設定
      // NavigationDestination(icon: const Icon(Icons.emoji_events_outlined), label: ''),
    ];
    return NavigationBar(
      selectedIndex: pageType.index,
      destinations: destinations,
      backgroundColor: Colors.white10,
      onDestinationSelected: (int index) {
        final pageType = PageType.values[index];
        pageTypeNotifier.state = pageType;
        switch (pageType) {
          case PageType.home:
            router.go(RouterPath.home);
            break;
          case PageType.profile:
            // ボトムナビゲーションから遷移する場合はログインユーザのプロフィールを表示
            router.goNamed(
              RouterPath.profile,
              queryParams: {
                'userId': userState?.id ?? '',
                'canEdit': 'true',
                'previousPagePath': RouterPath.home,
              },
            );
            break;
        }
      },
    );
  }
}
