import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_bar_ui_method_channel.dart';

abstract class AppBarUiPlatform extends PlatformInterface {
  /// Constructs a AppBarUiPlatform.
  AppBarUiPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppBarUiPlatform _instance = MethodChannelAppBarUi();

  /// The default instance of [AppBarUiPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppBarUi].
  static AppBarUiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppBarUiPlatform] when
  /// they register themselves.
  static set instance(AppBarUiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
