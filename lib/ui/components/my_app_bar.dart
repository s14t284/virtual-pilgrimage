import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends ConsumerWidget with PreferredSizeWidget {
  const MyAppBar({this.isLogin = true, this.tabBar, super.key});

  final bool isLogin;
  final PreferredSizeWidget? tabBar;
  static const appTitle = '巡礼ウォーク';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    final textStyle = TextStyle(color: color);
    return AppBar(title: Text(appTitle, style: textStyle), bottom: tabBar);
  }

  @override
  Size get preferredSize =>
      // tabBar が存在するときは tabBar のサイズを加算して AppBar の高さとする
      Size.fromHeight(kToolbarHeight + (tabBar?.preferredSize.height ?? 0));
}
