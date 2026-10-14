import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.common.widgets.widgetCanvas
import qs.modules.common.desktopMediaWidget
import qs.services

/**
 * Desktop media widget.
 *
 * An always-on-top, free-floating, draggable media controller. By default it
 * lives on the Wayland overlay layer (above normal windows) and persists across
 * workspaces. Its position is stored in Config.options.mediaWidget. When locked
 * (the lock button), it instead drops to the Bottom layer so it sits behind open
 * windows, like a desktop widget: either pinned to one workspace, or (with
 * Config.options.mediaWidget.lockAllWorkspaces) on every workspace.
 *
 * Deliberately panel-family agnostic: it is loaded from shell.qml, so it works
 * for both the "ii" and "waffle" families.
 */
Scope {
    id: root

    // Music visualizer data (shared by every screen instance)
    property list<real> visualizerPoints: []

    Process {
        id: cavaProc
        running: Config.ready
            && Config.options.mediaWidget.enable
            && Config.options.mediaWidget.showVisualizer
            && MprisController.isPlaying
        onRunningChanged: {
            if (!cavaProc.running)
                root.visualizerPoints = [];
        }
        command: ["cava", "-p", `${FileUtils.trimFileProtocol(Directories.scriptPath)}/cava/raw_output_config.txt`]
        stdout: SplitParser {
            onRead: data => {
                let points = data.split(";").map(p => parseFloat(p.trim())).filter(p => !isNaN(p));
                root.visualizerPoints = points;
            }
        }
    }

    // Which screen the widget lives on ("" = the first/primary screen)
    readonly property var selectedScreen: {
        const screens = Quickshell.screens;
        const name = Config.options.mediaWidget.screen;
        return screens.find(s => s.name === name) ?? screens[0];
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            required property var modelData
            screen: modelData

            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
            readonly property int currentWorkspace: monitor?.activeWorkspace?.id ?? 1
            readonly property bool isSelectedScreen: modelData === root.selectedScreen

            // A workspace on this monitor is showing a fullscreen window
            readonly property bool hasFullscreen: Hyprland.workspaces.values.filter(
                ws => ws.monitor && ws.monitor.name == monitor?.name && ws.active
                    && ws.toplevels.values.filter(toplevel => toplevel.wayland?.fullscreen)[0] !== undefined
            ).length > 0

            // Locked and set to "show on every workspace": stay visible
            // everywhere (just behind windows). Locked otherwise: only on the
            // pinned workspace. Unlocked: always visible.
            readonly property bool onPinnedWorkspace: !Config.options.mediaWidget.lockToWorkspace
                || Config.options.mediaWidget.lockAllWorkspaces
                || currentWorkspace === Config.options.mediaWidget.workspace
            readonly property bool hideForLock: GlobalStates.screenLocked && !Config.options.mediaWidget.showWhenLocked
            readonly property bool hideForFullscreen: Config.options.mediaWidget.hideWhenFullscreen && hasFullscreen
            readonly property bool hideForNoPlayer: Config.options.mediaWidget.hideWhenNoPlayer && !(MprisController.activePlayer)

            visible: Config.ready
                && Config.options.mediaWidget.enable
                && isSelectedScreen
                && onPinnedWorkspace
                && !hideForLock
                && !hideForFullscreen
                && !hideForNoPlayer

            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            WlrLayershell.namespace: "quickshell:desktopMediaWidget"
            // Unlocked: float above every window. Locked: behave like a desktop
            // widget, sitting behind normal windows (on one workspace, or on every
            // workspace when lockAllWorkspaces is set). The Bottom layer is above
            // the wallpaper and below windows; a small "order" layer rule in the
            // Hyprland config (rules.lua) keeps the wallpaper ordered below this
            // surface so the widget stays visible.
            WlrLayershell.layer: Config.options.mediaWidget.lockToWorkspace ? WlrLayer.Bottom : WlrLayer.Overlay
            // Pointer only: never steal keyboard focus from the focused window
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            // Only the widget itself is clickable, everything else passes through
            mask: Region {
                item: widgetWrapper
            }

            AbstractWidget {
                id: widgetWrapper
                width: mediaWidget.implicitWidth
                height: mediaWidget.implicitHeight
                // Position comes from the config; dragging breaks this binding and
                // writes the new value back on release
                x: Config.options.mediaWidget.x
                y: Config.options.mediaWidget.y
                // Dragging should be 1:1, no trailing animation
                animateXPos: false
                animateYPos: false

                function clampAndStore() {
                    if (panelWindow.width < width || panelWindow.height < height)
                        return;
                    const maxX = Math.max(0, panelWindow.width - width);
                    const maxY = Math.max(0, panelWindow.height - height);
                    const clampedX = Math.max(0, Math.min(x, maxX));
                    const clampedY = Math.max(0, Math.min(y, maxY));
                    x = clampedX;
                    y = clampedY;
                    Config.options.mediaWidget.x = clampedX;
                    Config.options.mediaWidget.y = clampedY;
                }

                function reclampIfNeeded() {
                    // The panel goes through transient sizes while the surface is being
                    // set up (e.g. a bogus 100px width). Clamping against those would
                    // wrongly push the widget to 0,0, so only clamp once the panel is at
                    // least as large as the widget itself.
                    if (panelWindow.width < width || panelWindow.height < height)
                        return;
                    const maxX = Math.max(0, panelWindow.width - width);
                    const maxY = Math.max(0, panelWindow.height - height);
                    // Only clamp when out of bounds, so normal reloads don't rewrite the config
                    if (x > maxX || y > maxY || x < 0 || y < 0) {
                        Config.options.mediaWidget.x = Math.max(0, Math.min(x, maxX));
                        Config.options.mediaWidget.y = Math.max(0, Math.min(y, maxY));
                    }
                }

                Component.onCompleted: reclampIfNeeded()
                onReleased: clampAndStore()

                // Safety net for the case where the panel isn't sized yet at completion
                // (e.g. the saved position is on a monitor that no longer exists)
                Timer {
                    interval: 700
                    running: true
                    onTriggered: widgetWrapper.reclampIfNeeded()
                }

                MediaWidget {
                    id: mediaWidget
                    anchors.fill: parent
                    hovered: widgetWrapper.containsMouse
                    visualizerPoints: root.visualizerPoints
                    currentWorkspace: panelWindow.currentWorkspace
                    // Locking means "sit behind windows". Unless the widget is
                    // set to show on every workspace, also snapshot the current
                    // workspace so it stays visible here and stops following to
                    // other workspaces.
                    onToggleLockRequested: {
                        if (Config.options.mediaWidget.lockToWorkspace) {
                            Config.options.mediaWidget.lockToWorkspace = false;
                        } else {
                            if (!Config.options.mediaWidget.lockAllWorkspaces)
                                Config.options.mediaWidget.workspace = panelWindow.currentWorkspace;
                            Config.options.mediaWidget.lockToWorkspace = true;
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "mediaWidget"

        function toggle(): void {
            Config.options.mediaWidget.enable = !Config.options.mediaWidget.enable;
        }
        // Lock behind windows, pinned to the workspace that is focused right now
        // (unless the widget is set to show on every workspace).
        function lock(): void {
            if (!Config.options.mediaWidget.lockAllWorkspaces)
                Config.options.mediaWidget.workspace = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
            Config.options.mediaWidget.lockToWorkspace = true;
        }
        function unlock(): void {
            Config.options.mediaWidget.lockToWorkspace = false;
        }
        function toggleLock(): void {
            if (Config.options.mediaWidget.lockToWorkspace)
                Config.options.mediaWidget.lockToWorkspace = false;
            else
                lock();
        }
    }
}
