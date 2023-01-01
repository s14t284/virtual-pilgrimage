import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/analytics.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/router.dart';

final pageTypeProvider = StateProvider<PageType>((_) => PageType.home);

enum PageType {
  ranking,
  temple,
  home,
  profile,
  setting,
}

final Map<PageType, String> pageTypePathMapping = {
  PageType.ranking: RouterPath.ranking,
  PageType.temple: RouterPath.temple,
  PageType.home: RouterPath.home,
  PageType.profile: RouterPath.profile,
  PageType.setting: RouterPath.settings,
};

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    final pageType = ref.watch(pageTypeProvider);
    final pageTypeNotifier = ref.read(pageTypeProvider.notifier);
    final router = ref.read(routerProvider);
    final analytics = ref.read(analyticsProvider);

    final destinations = <Widget>[
      NavigationDestination(
        icon: const Icon(Icons.emoji_events_outlined),
        label: PageType.ranking.name,
      ),
      NavigationDestination(
        icon: const Icon(Icons.temple_hindu),
        label: PageType.temple.name,
      ),
      NavigationDestination(
        icon: const Icon(Icons.map_outlined),
        label: PageType.home.name,
      ),
      NavigationDestination(
        icon: const Icon(Icons.account_circle_outlined),
        label: PageType.profile.name,
      ),
      NavigationDestination(icon: const Icon(Icons.settings_outlined), label: PageType.setting.name)
    ];
    return NavigationBar(
      selectedIndex: pageType.index,
      destinations: destinations,
      backgroundColor: Colors.white70,
      onDestinationSelected: (int index) {
        final pageType = PageType.values[index];
        pageTypeNotifier.state = pageType;
        analytics.logEvent(
          eventName: AnalyticsEvent.pressedBottomNavigation,
          parameters: {'pageType': pageType.name},
        );
        switch (pageType) {
          case PageType.home:
          case PageType.temple:
          case PageType.ranking:
          case PageType.setting:
            router.go(pageTypePathMapping[pageType]!);
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
