import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';
import 'package:app_bar_ui/app_bar_ui_platform_interface.dart';
import 'package:app_bar_ui/app_bar_ui_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppBarUiPlatform
    with MockPlatformInterfaceMixin
    implements AppBarUiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppBarUiPlatform initialPlatform = AppBarUiPlatform.instance;

  test('$MethodChannelAppBarUi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppBarUi>());
  });

  test('getPlatformVersion', () async {
    AppBarUi appBarUiPlugin = AppBarUi();
    MockAppBarUiPlatform fakePlatform = MockAppBarUiPlatform();
    AppBarUiPlatform.instance = fakePlatform;

    expect(await appBarUiPlugin.getPlatformVersion(), '42');
  });
}
