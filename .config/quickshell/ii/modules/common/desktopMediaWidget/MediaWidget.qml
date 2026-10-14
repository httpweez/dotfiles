import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.ii.mediaControls
import qs.services

/**
 * The visual card of the desktop media widget.
 * Reuses the shell's PlayerControl so it matches the media popup design.
 * This component is not draggable by itself: the host wraps it in a MouseArea.
 */
Item {
    id: root

    // Provided by the host
    property var activePlayer: MprisController.activePlayer
    property var playerList: MprisController.players
    property list<real> visualizerPoints: []
    property int currentWorkspace: 1
    property bool hovered: false

    readonly property bool locked: Config.options.mediaWidget.lockToWorkspace
    readonly property bool hasPlayer: root.activePlayer !== null && root.activePlayer !== undefined

    signal toggleLockRequested()

    implicitWidth: Config.options.mediaWidget.width
    implicitHeight: Config.options.mediaWidget.height

    function cyclePlayer() {
        if (root.playerList.length < 2)
            return;
        let index = root.playerList.indexOf(root.activePlayer);
        index = (index + 1) % root.playerList.length;
        MprisController.setActivePlayer(root.playerList[index]);
    }

    // The actual media card (only when a player exists)
    Loader {
        anchors.fill: parent
        active: root.hasPlayer
        sourceComponent: PlayerControl {
            player: root.activePlayer
            visualizerPoints: root.visualizerPoints
            implicitWidth: root.width
            implicitHeight: root.height
            radius: Appearance.rounding.large
        }
    }

    // Placeholder when nothing is playing
    Loader {
        anchors.fill: parent
        active: !root.hasPlayer
        sourceComponent: Item {
            StyledRectangularShadow {
                target: placeholderCard
            }
            Rectangle {
                id: placeholderCard
                anchors.fill: parent
                anchors.margins: Appearance.sizes.elevationMargin
                radius: Appearance.rounding.large
                color: Appearance.colors.colLayer0

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    MaterialSymbol {
                        Layout.alignment: Qt.AlignHCenter
                        text: "music_off"
                        iconSize: 40
                        color: Appearance.colors.colSubtext
                    }
                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: Translation.tr("No media playing")
                        color: Appearance.colors.colSubtext
                        font.pixelSize: Appearance.font.pixelSize.large
                    }
                }
            }
        }
    }

    // Floating chrome (appears on hover), kept above the card
    RowLayout {
        id: chromeRow
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Appearance.sizes.elevationMargin + 6
        spacing: 6
        opacity: (root.hovered || root.locked) ? 1 : 0
        visible: opacity > 0
        z: 2

        Behavior on opacity {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }

        ChromeButton {
            visible: root.playerList.length > 1
            iconName: "swap_horiz"
            tooltipText: Translation.tr("Switch player")
            onActivated: root.cyclePlayer()
        }

        ChromeButton {
            iconName: root.locked ? "lock" : "lock_open"
            accented: root.locked
            tooltipText: root.locked
                ? (Config.options.mediaWidget.lockAllWorkspaces
                    ? Translation.tr("Behind windows on every workspace · click to float above every window")
                    : Translation.tr("Behind windows on workspace %1 · click to float above every window").arg(Config.options.mediaWidget.workspace))
                : Translation.tr("Floating above windows · click to pin behind windows on workspace %1").arg(root.currentWorkspace)
            onActivated: root.toggleLockRequested()
        }
    }

    component ChromeButton: RippleButton {
        id: chromeButton
        property string iconName
        property string tooltipText
        property bool accented: false

        signal activated

        implicitWidth: 32
        implicitHeight: 32
        buttonRadius: Appearance.rounding.full
        colBackground: ColorUtils.transparentize(Appearance.colors.colLayer0, 0.25)
        colBackgroundHover: Appearance.colors.colLayer0Hover
        colBackgroundToggled: Appearance.colors.colPrimary
        colBackgroundToggledHover: Appearance.colors.colPrimaryHover
        toggled: chromeButton.accented
        downAction: () => chromeButton.activated()

        contentItem: MaterialSymbol {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            iconSize: 18
            fill: 1
            text: chromeButton.iconName
            color: chromeButton.accented ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
        }

        StyledToolTip {
            text: chromeButton.tooltipText
        }
    }
}
