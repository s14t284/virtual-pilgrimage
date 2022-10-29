import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:virtualpilgrimage/ui/pages/home/home_presenter.dart';

// TODO(s14t284): お試しで Google Map を表示しているだけであるため、必要に応じて修正する
class GoogleMapView extends ConsumerWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return SizedBox(
      height: 350, // FIXME: 適当に固定値を設定しているので修正する
      child: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: false,
        scrollGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: state.initialCameraPosition,
        markers: state.markers,
        polylines: state.polylines,
        onMapCreated: notifier.onMapCreated,
        // スクロールジェスチャーが正常にできるような設定
        gestureRecognizers: const {
          Factory<OneSequenceGestureRecognizer>(
            EagerGestureRecognizer.new,
          )
        },
      ),
    );
  }
}
