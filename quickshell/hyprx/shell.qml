import QtQuick
import Quickshell
import Quickshell.Io
import "services"
import "island"
import "notifications"

ShellRoot {
    id: root

    IslandRouter { id: router }
    ThemeService { id: themeService }
    WallpaperService { id: wallpaperService; themeService: themeService }
    AppearanceService { id: appearanceService }
    BackgroundService { id: backgroundService }
    SettingsService { id: settingsService }
    RecorderService { id: recorderService }
    AppService { id: appService }
    MediaService { id: mediaService }
    SystemService { id: systemService }
    NotificationService { id: notificationService }

    Island {
        router: router
        themeService: themeService
        wallpaperService: wallpaperService
        appearanceService: appearanceService
        backgroundService: backgroundService
        settingsService: settingsService
        recorderService: recorderService
        appService: appService
        mediaService: mediaService
        systemService: systemService
        notificationService: notificationService
    }

    OnScreenDisplay {
        systemService: systemService
        settingsService: settingsService
    }

    NotificationToasts { service: notificationService }

    IpcHandler {
        target: "hyprx"
        function island(): void { router.toggle("media") }
        function media(): void { router.toggle("media") }
        function launcher(): void { router.toggle("launcher") }
        function calendar(): void { router.toggle("calendar") }
        function settings(): void { router.toggle("settings") }
        function theme(): void { router.toggle("theme") }
        function wallpaper(): void { router.toggle("wallpaper") }
        function control(): void { router.toggle("control") }
        function notifications(): void { router.toggle("notifications") }
        function power(): void { router.toggle("power") }
        function lock(): void { systemService.lock() }
        function recorder(): void { recorderService.toggle() }
        function monitor(): void { systemService.openSystemMonitor() }
        function reloadtheme(): void { themeService.refresh() }
        function hide(): void { router.close() }
    }
}
