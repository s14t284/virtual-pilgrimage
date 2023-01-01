import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_crashlytics_provider.dart';
import 'package:virtualpilgrimage/ui/components/bottom_navigation.dart';
import 'package:virtualpilgrimage/ui/components/my_app_bar.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/components/ranking_records.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/components/ranking_tab_bars.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/ranking_presenter.dart';

class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> with TickerProviderStateMixin {
  late final TabController _rankingKindTabController;
  late final TabController _periodTabController;

  @override
  void initState() {
    _rankingKindTabController = TabController(length: 2, vsync: this);
    _periodTabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabColor = Theme.of(context).colorScheme.onPrimaryContainer;

    // 集計項目に関するTabBar
    final kindTabBar = TabBar(
      controller: _rankingKindTabController,
      labelColor: tabColor,
      unselectedLabelColor: tabColor,
      indicatorColor: tabColor,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(text: '歩数', icon: Icon(Icons.directions_run_rounded)),
        Tab(text: '距離', icon: Icon(Icons.map_outlined)),
      ],
    );
    // 集計期間に関するTabBar
    final periodTabBar = TabBar(
      controller: _periodTabController,
      labelColor: tabColor,
      unselectedLabelColor: tabColor,
      indicatorColor: tabColor,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: ref
          .read(rankingPresenterProvider.notifier)
          .periodTabLabels
          .map((l) => Tab(text: l))
          .toList(),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(tabBar: RankingTabBars(tabBars: [kindTabBar, periodTabBar])),
        body: SafeArea(
          child: TabBarView(
            controller: _rankingKindTabController,
            children: [
              _RankingPageBody(
                ref: ref,
                periodTabController: _periodTabController,
                kind: RankingKind.steps,
              ),
              _RankingPageBody(
                ref: ref,
                periodTabController: _periodTabController,
                kind: RankingKind.distances,
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}

class _RankingPageBody extends StatelessWidget {
  const _RankingPageBody({
    required this.ref,
    required this.periodTabController,
    required this.kind,
  });

  final WidgetRef ref;
  final TabController periodTabController;
  final RankingKind kind;

  @override
  Widget build(BuildContext context) {
    final ranking = ref.watch(rankingProvider);
    final notifier = ref.read(rankingPresenterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '最終更新日: ${notifier.convertUpdatedTimeToDisplayFormat(ranking.value, RankingPeriod.values[periodTabController.index])} (毎日4時頃更新予定)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: periodTabController,
            children: [
              _buildRankingRecords(context, ref, ranking, kind, RankingPeriod.daily),
              _buildRankingRecords(context, ref, ranking, kind, RankingPeriod.weekly),
              _buildRankingRecords(context, ref, ranking, kind, RankingPeriod.monthly),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildRankingRecords(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Ranking> ranking,
    RankingKind kind,
    RankingPeriod period,
  ) {
    return Column(
      children: [
        ranking.when(
          data: (ranking) => RankingRecords(ranking: ranking, kind: kind, period: period),
          // TODO(s14t284): error 時のUIを整理する
          error: (Object error, StackTrace stackTrace) {
            ref.read(firebaseCrashlyticsProvider).recordError(error, stackTrace);
            return const Text('ランキング情報が取得できませんでした');
          },
          loading: () {
            return Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  strokeWidth: 16,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
