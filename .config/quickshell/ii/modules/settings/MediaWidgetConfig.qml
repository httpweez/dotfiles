import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    id: root
    forceWidth: true

    readonly property var screenOptions: {
        let options = [{
            "displayName": Translation.tr("Primary"),
            "icon": "star",
            "value": ""
        }];
        for (const screen of Quickshell.screens) {
            options.push({
                "displayName": screen.name,
                "icon": "monitor",
                "value": screen.name
            });
        }
        return options;
    }

    ContentSection {
        icon: "music_note"
        title: Translation.tr("Desktop media widget")

        ConfigSwitch {
            buttonIcon: "toggle_on"
            text: Translation.tr("Enable the widget")
            checked: Config.options.mediaWidget.enable
            onCheckedChanged: {
                Config.options.mediaWidget.enable = checked;
            }
            StyledToolTip {
                text: Translation.tr("A floating, draggable media controller for any MPRIS player. Floats above windows, or sits behind them when pinned to a workspace.")
            }
        }

        ConfigSlider {
            text: Translation.tr("X position")
            buttonIcon: "pin_drop"
            usePercentTooltip: false
            textWidth: 120
            from: 0
            to: 1920
            value: Config.options.mediaWidget.x
            onValueChanged: {
                Config.options.mediaWidget.x = value;
            }
        }
        ConfigSlider {
            text: Translation.tr("Y position")
            buttonIcon: "pin_drop"
            usePercentTooltip: false
            textWidth: 120
            from: 0
            to: 1080
            value: Config.options.mediaWidget.y
            onValueChanged: {
                Config.options.mediaWidget.y = value;
            }
        }
    }

    ContentSection {
        icon: "aspect_ratio"
        title: Translation.tr("Size & placement")

        ConfigSlider {
            text: Translation.tr("Width")
            buttonIcon: "width"
            usePercentTooltip: false
            textWidth: 120
            from: 240
            to: 720
            value: Config.options.mediaWidget.width
            onValueChanged: {
                Config.options.mediaWidget.width = value;
            }
        }
        ConfigSlider {
            text: Translation.tr("Height")
            buttonIcon: "height"
            usePercentTooltip: false
            textWidth: 120
            from: 100
            to: 300
            value: Config.options.mediaWidget.height
            onValueChanged: {
                Config.options.mediaWidget.height = value;
            }
        }

        ConfigRow {
            Layout.fillWidth: true
            ConfigSelectionArray {
                Layout.fillWidth: true
                currentValue: Config.options.mediaWidget.screen
                onSelected: newValue => {
                    Config.options.mediaWidget.screen = newValue;
                }
                options: root.screenOptions
            }
        }
    }

    ContentSection {
        icon: "visibility"
        title: Translation.tr("Behavior")

        ConfigSwitch {
            buttonIcon: "graphic_eq"
            text: Translation.tr("Music visualizer")
            checked: Config.options.mediaWidget.showVisualizer
            onCheckedChanged: {
                Config.options.mediaWidget.showVisualizer = checked;
            }
            StyledToolTip {
                text: Translation.tr("Animated bars over the album art (requires cava)")
            }
        }
        ConfigSwitch {
            buttonIcon: "fullscreen"
            text: Translation.tr("Hide when a window is fullscreen")
            checked: Config.options.mediaWidget.hideWhenFullscreen
            onCheckedChanged: {
                Config.options.mediaWidget.hideWhenFullscreen = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "music_off"
            text: Translation.tr("Hide when nothing is playing")
            checked: Config.options.mediaWidget.hideWhenNoPlayer
            onCheckedChanged: {
                Config.options.mediaWidget.hideWhenNoPlayer = checked;
            }
        }
        ConfigSwitch {
            buttonIcon: "lock"
            text: Translation.tr("Show on the lock screen")
            checked: Config.options.mediaWidget.showWhenLocked
            onCheckedChanged: {
                Config.options.mediaWidget.showWhenLocked = checked;
            }
        }
    }

    ContentSection {
        icon: "workspaces"
        title: Translation.tr("Workspaces")

        ConfigSwitch {
            buttonIcon: "lock"
            text: Translation.tr("Lock behind windows")
            checked: Config.options.mediaWidget.lockToWorkspace
            onCheckedChanged: {
                Config.options.mediaWidget.lockToWorkspace = checked;
            }
            StyledToolTip {
                text: Translation.tr("When locked, the widget sits behind open windows like a desktop widget. Otherwise it floats above every window. You can also toggle this with the lock button on the widget itself.")
            }
        }
        ConfigSwitch {
            buttonIcon: "select_all"
            text: Translation.tr("Show on every workspace")
            enabled: Config.options.mediaWidget.lockToWorkspace
            checked: Config.options.mediaWidget.lockAllWorkspaces
            onCheckedChanged: {
                Config.options.mediaWidget.lockAllWorkspaces = checked;
            }
            StyledToolTip {
                text: Translation.tr("When locked, keep the widget visible on every workspace (it just stays behind windows) instead of pinning it to one workspace. Off by default, so locking pins the widget to the workspace you are on.")
            }
        }
        ConfigRow {
            ConfigSpinBox {
                icon: "workspaces"
                text: Translation.tr("Workspace")
                enabled: Config.options.mediaWidget.lockToWorkspace && !Config.options.mediaWidget.lockAllWorkspaces
                value: Config.options.mediaWidget.workspace
                from: 1
                to: 100
                stepSize: 1
                onValueChanged: {
                    Config.options.mediaWidget.workspace = value;
                }
                StyledToolTip {
                    text: Translation.tr("The workspace the widget is pinned to. Only used while locked and not set to show on every workspace. The lock button pins it to the workspace you are on; you can also change it here.")
                }
            }
        }
    }
}
