import QtQuick
import Quickshell
import "services"
import "island"
import "notifications"

ShellRoot {
    id: root

    IslandRouter { id: router }
    ThemeService { id: themeService }
    WallpaperService { id: wallpaperService; themeService: themeService }
    AppService { id: appService }
    MediaService { id: mediaService }
    SystemService { id: systemService }
    NotificationService { id: notificationService }

    Island {
        router: router
        themeService: themeService
        wallpaperService: wallpaperService
        appService: appService
        mediaService: mediaService
        systemService: systemService
        notificationService: notificationService
    }

    NotificationToasts { service: notificationService }

    IpcHandler {
        target: "hyprx"
        function island(): void { router.toggle("media") }
        function media(): void { router.toggle("media") }
        function launcher(): void { router.toggle("launcher") }
        function theme(): void { router.toggle("theme") }
        function wallpaper(): void { wallpaperService.refresh(); router.toggle("wallpaper") }
        function control(): void { router.toggle("control") }
        function notifications(): void { router.toggle("notifications") }
        function power(): void { router.toggle("power") }
        function reloadtheme(): void { themeService.refresh(); wallpaperService.refresh() }
        function hide(): void { router.close() }
    }
}
