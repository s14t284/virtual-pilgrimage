import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:virtualpilgrimage/domain/user/virtual_pilgrimage_user.codegen.dart';
import 'package:virtualpilgrimage/infrastructure/firebase/firebase_analytics_provider.dart';
import 'package:virtualpilgrimage/logger.dart';

// analytics クラスに渡すイベント名を定義する extension
extension AnalyticsEvent on String {
  static const signInWithEmailAndPassword = 'sign_in_with_email_and_password';
  static const signInWithEmailAndPasswordFailed = 'sign_in_with_email_and_password_failed';
  static const signInWithGoogle = 'sign_in_with_google';
  static const signInWithGoogleFailed = 'sign_in_with_google_failed';
  static const signInWithApple = 'sign_in_with_apple';
  static const signInWithAppleFailed = 'sign_in_with_apple_failed';
  static const logout = 'logout';
  static const moveEditPage = 'move_edit_page';
  static const pressedRegistration = 'pressed_registration';
  static const registrationFailed = 'registration_failed';
  static const initializeHomePageAndGetHealth = 'initialize_home_page_and_get_health';
  static const pressedUploadImage = 'pressed_upload_image';
  static const reachTemple = 'reach_temple';

  /// ボトムナビゲーションの押下
  static const pressedBottomNavigation = 'pressed_bottom_navigation';

  /// ユーザ削除の押下
  static const openDeleteUserDialog = 'open_delete_user_dialog';

  /// ユーザ情報の削除に成功
  static const successDeleteUser = 'success_delete_user';
}

final analyticsProvider = Provider<Analytics>(
  (ref) => Analytics(ref.read(firebaseAnalyticsProvider), ref.read(loggerProvider)),
);

class Analytics {
  Analytics(this._analytics, this._logger);

  final FirebaseAnalytics _analytics;
  final Logger _logger;

  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (eventName.length > 40) {
      _logger.w(
        'firebase analytics log name must be 40 or less. [eventName][$eventName][parameters][$parameters]',
      );
      return Future.value();
    }

    return _analytics.logEvent(name: eventName, parameters: parameters);
  }

  Future<void> setCurrentScreen({required String screenName}) async {
    unawaited(logEvent(eventName: 'route_screen_$screenName'));
    await _analytics.setCurrentScreen(screenName: screenName);
  }

  Future<void> setUserProperties({required VirtualPilgrimageUser user}) async {
    final map = {
      VirtualPilgrimageUserPrivateFirestoreFieldKeys.id: user.id,
      VirtualPilgrimageUserPrivateFirestoreFieldKeys.nickname: user.nickname,
      VirtualPilgrimageUserPrivateFirestoreFieldKeys.gender: user.gender.name,
    };
    for (final entry in map.entries) {
      unawaited(_analytics.setUserProperty(name: entry.key, value: entry.value));
    }
  }
}
