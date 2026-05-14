import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import "namedays-data.js" as NameDays

PluginComponent {
    id: root

    property var todayNames: []
    property var yesterdayNames: []
    property var tomorrowNames: []
    property string todayText: ""
    property string tooltipText: ""

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
        onDateChanged: root.refresh()
    }

    Component.onCompleted: refresh()

    function refresh() {
        var now = systemClock.date;
        var yesterday = NameDays.getDateOffset(now, -1);
        var tomorrow = NameDays.getDateOffset(now, 1);

        todayNames = NameDays.getNamesForDateObj(now);
        yesterdayNames = NameDays.getNamesForDateObj(yesterday);
        tomorrowNames = NameDays.getNamesForDateObj(tomorrow);

        todayText = NameDays.joinNames(todayNames);

        var tJ = NameDays.joinNames(todayNames);
        var yJ = NameDays.joinNames(yesterdayNames);
        var tmJ = NameDays.joinNames(tomorrowNames);

        tooltipText = "Ma " + tJ + " ünnepli névnapját, tegnap " + yJ + " ünnepelte, holnap pedig " + tmJ + " névnapja lesz.";
    }

    function formatDate(date) {
        var months = [
            "január", "február", "március", "április", "május", "június",
            "július", "augusztus", "szeptember", "október", "november", "december"
        ];
        return date.getFullYear() + ". " + months[date.getMonth()] + " " + date.getDate() + ".";
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: root.todayText || "Névnap"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: 1
            anchors.horizontalCenter: parent.horizontalCenter

            StyledText {
                text: root.todayText || "Névnap"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        Column {
            spacing: Theme.spacingL

            StyledText {
                text: "Magyar Névnapok"
                font.pixelSize: Theme.fontSizeXLarge
                font.weight: Font.Bold
                color: Theme.surfaceText
            }

            StyledText {
                text: root.formatDate(systemClock.date)
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }

            Column {
                width: parent.width
                spacing: Theme.spacingS

                // Yesterday
                StyledRect {
                    width: parent.width
                    height: 56
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.spacingL
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.spacingXS

                        StyledText {
                            text: "Tegnap"
                            color: Theme.surfaceVariantText
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        StyledText {
                            text: NameDays.joinNames(root.yesterdayNames)
                            color: Theme.surfaceText
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                        }
                    }
                }

                // Today
                StyledRect {
                    width: parent.width
                    height: 64
                    radius: Theme.cornerRadius
                    color: Theme.withAlpha(Theme.primary, 0.15)

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.spacingL
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.spacingXS

                        StyledText {
                            text: "Ma"
                            color: Theme.primary
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: NameDays.joinNames(root.todayNames)
                            color: Theme.primary
                            font.pixelSize: Theme.fontSizeXLarge
                            font.weight: Font.Bold
                        }
                    }
                }

                // Tomorrow
                StyledRect {
                    width: parent.width
                    height: 56
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.spacingL
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.spacingXS

                        StyledText {
                            text: "Holnap"
                            color: Theme.surfaceVariantText
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        StyledText {
                            text: NameDays.joinNames(root.tomorrowNames)
                            color: Theme.surfaceText
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            StyledText {
                text: root.tooltipText
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }

    popoutWidth: 380
    popoutHeight: 380
}
