import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_crashlytics_provider.dart';
import 'package:virtualpilgrimage/router.dart';
import 'package:virtualpilgrimage/ui/components/bottom_navigation.dart';
import 'package:virtualpilgrimage/ui/components/molecules/pilgrimage_progress_card.dart';
import 'package:virtualpilgrimage/ui/components/molecules/profile_health_card.dart';
import 'package:virtualpilgrimage/ui/components/my_app_bar.dart';
import 'package:virtualpilgrimage/ui/pages/profile/components/profile_icon.dart';
import 'package:virtualpilgrimage/ui/pages/profile/components/profile_text.dart';
import 'package:virtualpilgrimage/ui/pages/profile/profile_presenter.dart';
import 'package:virtualpilgrimage/ui/pages/profile/profile_state.codegen.dart';
import 'package:virtualpilgrimage/ui/style/color.dart';
import 'package:virtualpilgrimage/ui/wording_helper.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    required this.userId,
    required this.canEdit,
    required this.previousPagePath,
    super.key,
  });

  final String userId;
  final bool canEdit;
  final String previousPagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    // ユーザ情報が null の場合、何も描画できないのでログインページに遷移させる
    if (userState == null) {
      ref.read(routerProvider).go(RouterPath.signIn);
    }
    final user = ref.watch(profileUserProvider(userId));

    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        // TODO(s14t284): error 時のUIを整理する
        child: user.when(
          data: (data) {
            if (data != null) {
              return _ProfilePageBody(user: data, canEdit: canEdit);
            }
            // TODO(s14t284): 他ユーザの情報を参照できるようになったら　null の場合の UI も実装する
            return const Text('そのユーザは存在しませんでした');
          },
          error: (e, s) {
            ref.read(firebaseCrashlyticsProvider).recordError(e, s);
            return const Text('ユーザのヘルスケア情報の取得に失敗しました');
          },
          loading: () {
            return ProfilePageLoadingBody(user: userState!);
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class _ProfilePageBody extends ConsumerWidget {
  const _ProfilePageBody({
    required this.user,
    required this.canEdit,
  });

  final VirtualPilgrimageUser user;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    return ListView(
      children: [
        ProfileIcon(user: user, canEdit: canEdit, context: context, notifier: notifier),
        ProfileText(user: user, context: context, notifier: notifier),
        _healthCards(context, user, notifier, state),
        pilgrimageProgressCardProvider(context, user, ref),
      ],
    );
  }

  Widget _healthCards(
    BuildContext context,
    VirtualPilgrimageUser user,
    ProfilePresenter notifier,
    ProfileState state,
  ) {
    final health = user.health;
    final List<List<ProfileHealthCard>> healthCards = [];
    if (health != null) {
      final healthByPeriod = [health.today, health.yesterday, health.week, health.month];
      for (final h in healthByPeriod) {
        healthCards.add([
          ProfileHealthCard(
            title: '歩数',
            value: h.steps.toString(),
            unit: '歩',
            backgroundColor: Colors.lightGreen,
            icon: Icons.directions_run_rounded,
          ),
          ProfileHealthCard(
            title: '移動距離',
            value: WordingHelper.meterToKilometerString(h.distance),
            unit: 'km',
            backgroundColor: Colors.lightBlue,
            icon: Icons.map_outlined,
          ),
          ProfileHealthCard(
            title: 'カロリー',
            value: h.burnedCalorie.toString(),
            unit: 'kcal',
            backgroundColor: Colors.orangeAccent,
            icon: Icons.local_fire_department_outlined,
          ),
        ]);
      }
    }
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          FlutterToggleTab(
            width: 60,
            labels: notifier.tabLabels(),
            selectedLabelIndex: (index) {
              notifier.setSelectedTabIndex(index);
            },
            selectedTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorStyle.white,
            ),
            unSelectedTextStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
            selectedIndex: state.selectedTabIndex,
          ),
          const SizedBox(height: 8),
          // クラッシュ対策のため、全てのヘルスチェック情報を取得できているときに表示
          if (healthCards.length == notifier.tabLabels().length)
            Row(children: healthCards[state.selectedTabIndex]),
        ],
      ),
    );
  }
}

// ローディング時のボディ
// お遍路の進捗やヘルスケア情報をローディングで埋めている
// MEMO: 実際はヘルスケア情報だけを取得してきているが、UIのわかりやすさ的にお遍路進捗もローディングで隠している
class ProfilePageLoadingBody extends ConsumerWidget {
  const ProfilePageLoadingBody({required this.user, super.key});

  final VirtualPilgrimageUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileProvider.notifier);
    return ListView(
      children: [
        ProfileIcon(user: user, canEdit: false, context: context, notifier: notifier),
        ProfileText(user: user, context: context, notifier: notifier),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                strokeWidth: 16,
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
