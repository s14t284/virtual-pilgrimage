import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking.codegen.dart';
import 'package:virtualpilgrimage/domain/ranking/ranking_user.codegen.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/ui/components/profile_icon.dart';
import 'package:virtualpilgrimage/ui/pages/ranking/ranking_presenter.dart';

class RankingRecords extends ConsumerWidget {
  const RankingRecords({
    required this.ranking,
    required this.kind,
    required this.period,
    super.key,
  });

  final Ranking ranking;
  final RankingKind kind;
  final RankingPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rankingPresenterProvider.notifier);
    final loginUserState = ref.watch(userStateProvider);
    final targetRanking = notifier.selectRanking(ranking, kind, period);

    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 10 * 6,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final target = targetRanking.users[index];
              return _buildRecord(context, notifier, target, loginUserState, index, kind);
            },
            itemCount: targetRanking.users.length,
          ),
        ),
      ),
    );
  }

  /// ランキングのListViewの1レコードのUI
  Widget _buildRecord(
    BuildContext context,
    RankingPresenter notifier,
    RankingUser user,
    VirtualPilgrimageUser? loginUser,
    int rank,
    RankingKind kind,
  ) {
    final isLoginUser = user.userId == loginUser?.id;

    return ListTile(
      key: Key('ranking_${rank + 1}'),
      tileColor: isLoginUser ? Theme.of(context).colorScheme.primaryContainer : Colors.white,
      leading: SizedBox(
        width: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${rank + 1} 位', style: const TextStyle(fontWeight: FontWeight.bold)),
            ProfileIconWidget(
              iconUrl: user.userIconUrl != '' ? user.userIconUrl : notifier.defaultProfileImageUrl,
              size: 48,
            ),
          ],
        ),
      ),
      title: Text(user.nickname),
      trailing: Text(
        notifier.convertRankingValueDisplayFormat(user.value, kind),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () => notifier.moveProfilePage(user.userId),
    );
  }
}
