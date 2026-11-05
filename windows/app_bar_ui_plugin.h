#ifndef FLUTTER_PLUGIN_APP_BAR_UI_PLUGIN_H_
#define FLUTTER_PLUGIN_APP_BAR_UI_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace app_bar_ui {

class AppBarUiPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AppBarUiPlugin();

  virtual ~AppBarUiPlugin();

  // Disallow copy and assign.
  AppBarUiPlugin(const AppBarUiPlugin&) = delete;
  AppBarUiPlugin& operator=(const AppBarUiPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace app_bar_ui

#endif  // FLUTTER_PLUGIN_APP_BAR_UI_PLUGIN_H_
