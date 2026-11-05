import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_bar_ui_platform_interface.dart';

/// An implementation of [AppBarUiPlatform] that uses method channels.
class MethodChannelAppBarUi extends AppBarUiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_bar_ui');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
