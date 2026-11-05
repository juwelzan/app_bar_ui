#include "include/app_bar_ui/app_bar_ui_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "app_bar_ui_plugin.h"

void AppBarUiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  app_bar_ui::AppBarUiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
