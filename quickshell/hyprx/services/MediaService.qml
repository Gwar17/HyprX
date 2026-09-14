import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Scope {
    id: service

    readonly property var players: Mpris.players.values
    readonly property var activePlayer: choosePlayer()

    readonly property bool available: activePlayer !== null
    readonly property string title:
        available && activePlayer.trackTitle ? activePlayer.trackTitle : "Nothing Playing"
    readonly property string artist:
        available && activePlayer.trackArtist ? activePlayer.trackArtist : ""
    readonly property string album:
        available && activePlayer.trackAlbum ? activePlayer.trackAlbum : ""
    readonly property string artwork:
        available && activePlayer.trackArtUrl ? activePlayer.trackArtUrl : ""

    readonly property bool playing:
        available && activePlayer.isPlaying

    readonly property real position:
        available && activePlayer.positionSupported ? activePlayer.position : 0
    readonly property real length:
        available && activePlayer.lengthSupported ? activePlayer.length : 0
    readonly property real volume:
        available && activePlayer.volumeSupported ? activePlayer.volume : 1

    readonly property bool canToggle:
        available && activePlayer.canTogglePlaying
    readonly property bool canPrevious:
        available && activePlayer.canGoPrevious
    readonly property bool canNext:
        available && activePlayer.canGoNext
    readonly property bool canSeek:
        available && activePlayer.canSeek
    readonly property bool canSetVolume:
        available && activePlayer.canControl && activePlayer.volumeSupported
    readonly property bool canShuffle:
        available && activePlayer.canControl && activePlayer.shuffleSupported
    readonly property bool canLoop:
        available && activePlayer.canControl && activePlayer.loopSupported

    readonly property bool shuffle:
        canShuffle && activePlayer.shuffle

    readonly property var loopState:
        canLoop ? activePlayer.loopState : MprisLoopState.None

    property bool positionMonitoring: false

    function choosePlayer() {
        const list = Mpris.players.values

        if (!list.length)
            return null

        for (let i = 0; i < list.length; ++i) {
            if (list[i].isPlaying)
                return list[i]
        }

        return list[0]
    }

    function togglePlaying() {
        if (canToggle)
            activePlayer.togglePlaying()
    }

    function previous() {
        if (canPrevious)
            activePlayer.previous()
    }

    function next() {
        if (canNext)
            activePlayer.next()
    }

    function seekTo(seconds) {
        if (!available || !canSeek || !activePlayer.positionSupported)
            return

        const target = Math.max(0, Math.min(activePlayer.length, seconds))
        activePlayer.position = target
    }

    function seekBy(seconds) {
        if (canSeek)
            activePlayer.seek(seconds)
    }

    function setVolume(value) {
        if (!canSetVolume)
            return

        activePlayer.volume = Math.max(0, Math.min(1, value))
    }

    function toggleShuffle() {
        if (canShuffle)
            activePlayer.shuffle = !activePlayer.shuffle
    }

    function cycleLoop() {
        if (!canLoop)
            return

        if (activePlayer.loopState === MprisLoopState.None)
            activePlayer.loopState = MprisLoopState.Track
        else if (activePlayer.loopState === MprisLoopState.Track)
            activePlayer.loopState = MprisLoopState.Playlist
        else
            activePlayer.loopState = MprisLoopState.None
    }

    Timer {
        interval: 1000
        repeat: true
        running: service.positionMonitoring
                 && service.available
                 && service.activePlayer.isPlaying

        onTriggered: service.activePlayer.positionChanged()
    }
}