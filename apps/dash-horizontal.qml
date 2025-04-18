/*
    Copyright 2018 - 2021 Benjamin Vedder	benjamin@vedder.se

    This file is part of VESC Tool.

    VESC Tool is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    VESC Tool is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    */

import QtQuick 2.6
// import QtQuick.Shapes 1.8
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import Vedder.vesc.vescinterface 1.0
import Vedder.vesc.utility 1.0
import Vedder.vesc.commands 1.0
import Vedder.vesc.configparams 1.0

Item {
    id: rtData
    property var dialogParent: ApplicationWindow.overlay
    anchors.fill: parent
    property date currentDate: new Date()

    property Commands mCommands: VescIf.commands()
    property ConfigParams mMcConf: VescIf.mcConfig()
    property int odometerValue: 0
    property double efficiency_lpf: 0
    property bool isHorizontal: rtData.width > rtData.height
    property bool showWidthHeight: false

    Component.onCompleted: {
        mCommands.emitEmptySetupValues()
    }

    // Make background slightly darker
    Rectangle {
        anchors.fill: parent
        color: {color = Utility.getAppHexColor("darkBackground")}
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        visible: isHorizontal

        Rectangle {
            id: topBar
            color: "transparent"
            // Layout.preferredHeight: clockMetrics.height
            height: clockText.height
            width: parent.width
            anchors.top: parent.top
            visible: false

            Text {
                id: clockText
                // anchors.centerIn: parent
                anchors.right: parent.right
                anchors.verticalCenter: topBar.verticalCenter
                font.pixelSize: 20
                font.weight: Font.DemiBold
                text: "12:40"
                font.family: "Exan"
                color: {color = Utility.getAppHexColor("lightText")}
            }

            Image {
                anchors.verticalCenter: clockText.verticalCenter
                anchors.right: clockText.left
                antialiasing: true
                opacity: 0.4
                height: parent.height*0.95
                fillMode: Image.PreserveAspectFit
                source: {source = "qrc" + Utility.getThemePath() + "icons/v_icon-96.png"}
                anchors.rightMargin: 5;
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: "white"
                opacity: 0.2
            }
        }

        Rectangle {
            color: "transparent"
            // height: parent.height - clockText.height
            // anchors.top: topBar.bottom
            height: parent.height
            anchors.top: parent.top
            width: parent.width

            Rectangle {
                id: ammeterBox
                color: "transparent"
                height: parent.height * 0.15
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 10

                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    id: ammeterRectsParent

                    Rectangle {
                        id: amp1
                        // color: "#0fffffff"
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp1_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp1_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp1_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp1_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp1_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("red")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("red")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "15"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp2
                        // color: "#0fffffff"
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp2_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp2_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp2_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp2_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp2_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "10"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp3
                        // color: "#0fffffff"
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp3_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp3_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp3_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp3_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp3_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "5"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp4
                        color: "#0fffffff"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "0"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp5
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp5_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp5_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp5_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp5_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp5_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "5"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp6
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp6_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp6_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp6_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp6_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp6_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "10"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp7
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp7_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp7_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp7_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp7_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp7_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "15"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp8
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp8_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp8_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp8_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp8_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp8_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "20"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp9
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp9_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp9_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp9_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp9_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp9_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "25"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp10
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp10_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp10_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp10_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp10_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp10_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("lightText")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("lightText")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "30"
                            font.family: "Exan"
                        }
                    }
                    Rectangle {
                        id: amp11
                        color: "transparent"
                        radius: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 5

                            Rectangle {
                                id: amp11_1
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp11_2
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp11_3
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp11_4
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle {
                                id: amp11_5
                                color: "#0fffffff"
                                radius: 5
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        Rectangle {
                            radius: 5
                            width: parent.width
                            height: 2
                            anchors.top: parent.bottom
                            anchors.topMargin: 5
                            color: Utility.getAppHexColor("red")
                        }

                        Text {
                            anchors.topMargin: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            color: {color = Utility.getAppHexColor("red")}
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            text: "35"
                            font.family: "Exan"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(rtData.width + " x " + rtData.height)
                        showWidthHeight = !showWidthHeight
                        // Add your custom logic here
                    }
                }
            }

            Text {
                id: speedValue
                anchors.right: speedUnit.left
                anchors.bottom: bottomBar.top
                anchors.bottomMargin: -20
                anchors.rightMargin: 10
                font.pixelSize: 160
                font.weight: Font.Bold
                text: "40"
                font.family: "Exan"
                color: {color = Utility.getAppHexColor("lightText")}
            }
            Text {
                id: speedUnit
                anchors.right: gear.left
                anchors.rightMargin: 20
                anchors.bottom: bottomBar.top
                font.pixelSize: 30
                font.weight: Font.DemiBold
                text: "km/h"
                font.family: "Exan"
                color: {color = Utility.getAppHexColor("lightText")}

                Text {
                    id: speedGnss
                    anchors.left: speedUnit.left
                    anchors.bottom: speedUnit.top
                    font.pixelSize: 30
                    font.weight: Font.DemiBold
                    text: "(24)"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
               }
            }
            Text {
                id: gear
                anchors.right: fuelRect.left
                anchors.rightMargin: 20
                anchors.bottom: bottomBar.top
                font.pixelSize: 80
                font.weight: Font.Bold
                text: "N"
                font.family: "Exan"
                color: {color = Utility.getAppHexColor("lightText")}
            }

            Rectangle {
                id: fuelRect
                color: "transparent"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: 100
                height: 170

                Text {
                    id: fuelFLabel
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    text: "F"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }

                Text {
                    id: fuelELabel
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    text: "E"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }

                Text {
                    id: fuelLabel
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    text: "100"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }

                Rectangle {
                    width: 2
                    anchors.leftMargin: 2
                    anchors.left: fuelFLabel.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    height: parent.height - 6
                    color: "white"
                    opacity: 0.2
                }

                /*Shape {
                    id: fuelShape
                    anchors.bottomMargin: 2
                    height: parent.height - 6
                    width: parent.width - (fuelFLabel.width + 2)
                    ShapePath {

                        PathLine { x: 0; y: fuelShape.height }
                        PathLine { x: fuelShape.width; y: fuelShape.height }
                        PathLine { x: fuelShape.width / 3; y: 0 }
                    }
                }*/

                Canvas {
                    id: fuelBgCanvas
                    anchors.left: fuelFLabel.right
                    anchors.leftMargin: 8
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    height: parent.height - 6
                    width: parent.width - (fuelFLabel.width + 8)
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.fillStyle = Qt.rgba(0, 0, 0, 0);
                        ctx.fillRect(0, 0, width, height);

                        ctx.beginPath();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(fuelBgCanvas.width, 0);
                        ctx.lineTo(fuelBgCanvas.width / 3, fuelBgCanvas.height);
                        ctx.lineTo(0, fuelBgCanvas.height);
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 0.06);
                        ctx.fill();
                    }
                }

                Canvas {
                    id: fuelMaskCanvas
                    anchors.left: fuelFLabel.right
                    anchors.leftMargin: 8
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    height: parent.height - 6
                    width: parent.width - (fuelFLabel.width + 8)
                    property var value: 1.0
                    visible: false
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.fillStyle = Qt.rgba(0, 0, 0, 0);
                        ctx.fillRect(0, 0, width, height);

                        const y = fuelMaskCanvas.height * (1.0 - value);
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 1);
                        ctx.fillRect(0, y, fuelMaskCanvas.width, fuelMaskCanvas.height - y);
                        // ctx.restore();
                    }
                }

                Canvas {
                    id: fuelCanvas
                    anchors.left: fuelFLabel.right
                    anchors.leftMargin: 8
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2
                    height: parent.height - 6
                    width: parent.width - (fuelFLabel.width + 8)
                    visible: false
                    // property var value: 1.0
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.fillStyle = Qt.rgba(0, 0, 0, 0);
                        ctx.fillRect(0, 0, width, height);
                        const linGrad = ctx.createLinearGradient(0, 0, 0, fuelCanvas.height);
                        linGrad.addColorStop(0.6, "#ffffff");
                        linGrad.addColorStop(1, Utility.getAppHexColor("lightAccent"));

                        /*ctx.save();
                        const y = fuelCanvas.height * (1 - value);
                        //let p = new Path2D();//
                        ctx.rect(0, y, fuelCanvas.width, fuelCanvas.height - y);
                        // ctx.strokeStyle = "transparent";
                        ctx.strokeStyle = Qt.rgba(1, 0, 0, 1);
                        ctx.clip();*/

                        ctx.beginPath();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(fuelCanvas.width, 0);
                        ctx.lineTo(fuelCanvas.width / 3, fuelCanvas.height);
                        ctx.lineTo(0, fuelCanvas.height);
                        // ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
                        ctx.fillStyle = linGrad;
                        ctx.fill();
                        // ctx.restore();
                    }
                }

                OpacityMask {
                    anchors.fill: fuelCanvas
                    source: fuelCanvas
                    maskSource: fuelMaskCanvas
                }
            }

            Rectangle {
                id: bottomBar
                color: "transparent"
                // Layout.preferredHeight: clockMetrics.height
                height: tripHeader.height
                width: parent.width - 100
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 25

                Rectangle {
                    id: tripBox
                    color: "transparent"
                    width: 200
                    anchors.bottom: bottomBar.bottom
                    height: (tripRect.height) * 6

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: currentHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "BAT CUR: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: currentText
                                anchors.right: currentUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "20"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: currentUnit
                                anchors.right: parent.right
                                anchors.bottom: currentText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "A"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }

                        Rectangle {
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: voltageHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "VOLTAGE: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: voltageText
                                anchors.right: voltageUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "40"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: voltageUnit
                                anchors.right: parent.right
                                anchors.bottom: voltageText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "V"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }

                        Rectangle {
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: tempHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "TEMP: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: tempText
                                anchors.right: tempUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "12"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: tempUnit
                                anchors.right: parent.right
                                anchors.bottom: tempText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "\u00B0C"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }

                        Rectangle {
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: consumptionHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "CONSUMP: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: consumptionText
                                anchors.right: consumptionUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "12"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: consumptionUnit
                                anchors.right: parent.right
                                anchors.bottom: consumptionText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "Wh/km"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }

                        Rectangle {
                            id: tripRect
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: tripHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "TRIP: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: tripText
                                anchors.right: tripUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "12"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: tripUnit
                                anchors.right: parent.right
                                anchors.bottom: tripText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "km"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }

                        Rectangle {
                            height: tripHeader.height
                            width: parent.width
                            color: "transparent"

                            Text {
                                id: rangeHeader
                                anchors.left: parent.left
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "RANGE: "
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }

                            Text {
                                id: rangeText
                                anchors.right: rangeUnit.left
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                text: "16"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                            Text {
                                id: rangeUnit
                                anchors.right: parent.right
                                anchors.bottom: rangeText.bottom
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                text: "km"
                                font.family: "Exan"
                                color: {color = Utility.getAppHexColor("lightText")}
                            }
                        }
                    }
                }

                Text {
                    id: lockText
                    // anchors.centerIn: parent
                    anchors.right: offText.left
                    anchors.verticalCenter: bottomBar.verticalCenter
                    anchors.rightMargin: 20
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "LOCKED"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("tertiary1")}
                }

                Text {
                    id: offText
                    // anchors.centerIn: parent
                    anchors.right: light.left
                    anchors.verticalCenter: bottomBar.verticalCenter
                    anchors.rightMargin: 20
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "OFF"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("tertiary1")}
                }

                Text {
                    id: light
                    // anchors.centerIn: parent
                    anchors.right: mode.left
                    anchors.verticalCenter: bottomBar.verticalCenter
                    anchors.rightMargin: 20
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "LIGHT"
                    font.family: "Exan"
                    color: "green"
                }

                Text {
                    id: mode
                    // anchors.centerIn: parent
                    anchors.right: parent.right
                    anchors.verticalCenter: bottomBar.verticalCenter
                    anchors.rightMargin: 20
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "DEMON"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("red")}
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 2
                    color: "white"
                    opacity: 0.2
                }

                Text {
                    id: clockTextBottom
                    // anchors.centerIn: parent
                    anchors.left: parent.left
                    anchors.top: parent.bottom
                    anchors.topMargin: 2
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    text: "12:40"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }

                Image {
                    anchors.top: parent.bottom
                    anchors.topMargin: 4
                    anchors.left: clockTextBottom.right
                    anchors.leftMargin: 4
                    antialiasing: true
                    opacity: 0.4
                    height: clockTextBottom.height*0.95
                    fillMode: Image.PreserveAspectFit
                    source: {source = "qrc" + Utility.getThemePath() + "icons/v_icon-96.png"}
                    anchors.rightMargin: 5;
                }

                Text {
                    id: odoText
                    anchors.top: parent.bottom
                    anchors.topMargin: 4
                    anchors.right: odoUnit.left
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    text: "122.2"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }
                Text {
                    id: odoUnit
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.bottom: odoText.bottom
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    text: "km"
                    font.family: "Exan"
                    color: {color = Utility.getAppHexColor("lightText")}
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: {color = Utility.getAppHexColor("red")}
        visible: !isHorizontal

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            font.pixelSize: 30
            font.weight: Font.Bold
            text: "Rotate your screen"
            font.family: "Exan"
            wrapMode: "WordWrap"
            width: parent.width
            color: {color = Utility.getAppHexColor("lightText")}
        }
    }

    Rectangle {
        id: widthHeightRect
        visible: !isHorizontal || showWidthHeight
        anchors.centerIn: rtData
        color: {color = Utility.getAppHexColor("lightAccent")}
        width: widthHeightText.width + 15
        height: widthHeightText.height + 5
        Text {
            id: widthHeightText
            anchors.centerIn: parent
            font.pixelSize: 40
            font.weight: Font.Bold
            text: rtData.width + " x " + rtData.height
            font.family: "Exan"
            color: {color = Utility.getAppHexColor("lightText")}
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 100

        onTriggered: {
            mCommands.getValues()
            mCommands.getValuesSetup()
//            mCommands.bmsGetValues()
//            mCommands.ioBoardGetAll(255)
//            mCommands.getStats(0xFFFFFFFF)
            mCommands.getGnss(0xFFFF)
//            mCommands.getImuData(0xFFFFFFFF)
        }
    }

    Connections {
        id: commandsUpdate
        target: mCommands

        function interpolateAlpha(value, minValue, maxValue, minAlpha, maxAlpha) {
            if (value <= minValue) {
                return minAlpha;
            } else if (value >= maxValue) {
                return maxAlpha;
            } else {
                return minAlpha + (maxAlpha - minAlpha) * (value - minValue) / (maxValue - minValue);
            }
        }

        function compileAlpha(color, alpha) {
            let alphaCode = Math.round(alpha).toString(16);
            if(alphaCode.length == 1) {
                alphaCode = "0" + alphaCode;
            }
            return "#" + alphaCode + color.substring(1)
        }

        property var idMap: ({
            amp1: amp1, amp1_1: amp1_1, amp1_2: amp1_2, amp1_3: amp1_3, amp1_4: amp1_4, amp1_5: amp1_5,
            amp2: amp2, amp2_1: amp2_1, amp2_2: amp2_2, amp2_3: amp2_3, amp2_4: amp2_4, amp2_5: amp2_5,
            amp3: amp3, amp3_1: amp3_1, amp3_2: amp3_2, amp3_3: amp3_3, amp3_4: amp3_4, amp3_5: amp3_5,
            amp4: amp4,
            amp5: amp5, amp5_1: amp5_1, amp5_2: amp5_2, amp5_3: amp5_3, amp5_4: amp5_4, amp5_5: amp5_5,
            amp6: amp6, amp6_1: amp6_1, amp6_2: amp6_2, amp6_3: amp6_3, amp6_4: amp6_4, amp6_5: amp6_5,
            amp7: amp7, amp7_1: amp7_1, amp7_2: amp7_2, amp7_3: amp7_3, amp7_4: amp7_4, amp7_5: amp7_5,
            amp8: amp8, amp8_1: amp8_1, amp8_2: amp8_2, amp8_3: amp8_3, amp8_4: amp8_4, amp8_5: amp8_5,
            amp9: amp9, amp9_1: amp9_1, amp9_2: amp9_2, amp9_3: amp9_3, amp9_4: amp9_4, amp9_5: amp9_5,
            amp10: amp10, amp10_1: amp10_1, amp10_2: amp10_2, amp10_3: amp10_3, amp10_4: amp10_4, amp10_5: amp10_5,
            amp11: amp11, amp11_1: amp11_1, amp11_2: amp11_2, amp11_3: amp11_3, amp11_4: amp11_4, amp11_5: amp11_5,
        })
        function setAmpNeg(id, current, min, max, color) {
            const _1 = interpolateAlpha(current, min, min + 1, 255, 15)
            const _2 = interpolateAlpha(current, min + 1, min + 2, 255, 15)
            const _3 = interpolateAlpha(current, min + 2, min + 3, 255, 15)
            const _4 = interpolateAlpha(current, min + 3, min + 4, 255, 15)
            const _5 = interpolateAlpha(current, min + 4, min + 5, 255, 15)

            idMap[id + "_1"].color = compileAlpha(color, _1);
            idMap[id + "_2"].color = compileAlpha(color, _2);
            idMap[id + "_3"].color = compileAlpha(color, _3);
            idMap[id + "_4"].color = compileAlpha(color, _4);
            idMap[id + "_5"].color = compileAlpha(color, _5);
        }
        function setAmp(id, current, min, max, color) {
            const _1 = interpolateAlpha(current, min, min + 1, 15, 255)
            const _2 = interpolateAlpha(current, min + 1, min + 2, 15, 255)
            const _3 = interpolateAlpha(current, min + 2, min + 3, 15, 255)
            const _4 = interpolateAlpha(current, min + 3, min + 4, 15, 255)
            const _5 = interpolateAlpha(current, min + 4, min + 5, 15, 255)

            idMap[id + "_1"].color = compileAlpha(color, _1);
            idMap[id + "_2"].color = compileAlpha(color, _2);
            idMap[id + "_3"].color = compileAlpha(color, _3);
            idMap[id + "_4"].color = compileAlpha(color, _4);
            idMap[id + "_5"].color = compileAlpha(color, _5);
        }

        function setCurrent(current) {

            // colorBase = [ 15, 255, 255, 255 ];
            let color = "#ffffff";

            if(current < -10 || current > 30) {
                color = Utility.getAppHexColor("red");
            }

            amp4.color = compileAlpha(color, 255);

            setAmpNeg("amp1", current, -15, -10, color);
            setAmpNeg("amp2", current, -10, -5, color);
            setAmpNeg("amp3", current, -5, 0, color);
            // setAmpNeg("amp4", current, -15, -10, color);
            setAmp("amp5", current, 0, 5, color);
            setAmp("amp6", current, 5, 10, color);
            setAmp("amp7", current, 10, 15, color);
            setAmp("amp8", current, 15, 20, color);
            setAmp("amp9", current, 20, 25, color);
            setAmp("amp10", current, 25, 30, color);
            setAmp("amp11", current, 30, 35, color);

            /*const amp1opacity =  interpolateAlpha(current, -15,   -10,   255, 15);
            const amp2opacity =  interpolateAlpha(current, -10,   -5,    255, 15);
            const amp3opacity =  interpolateAlpha(current, -5,    0,     255, 15);
            const amp4opacity =  255;
            const amp5opacity =  interpolateAlpha(current, 0,     5,     15, 255);
            const amp6opacity =  interpolateAlpha(current, 5,     10,    15, 255);
            const amp7opacity =  interpolateAlpha(current, 10,    15,    15, 255);
            const amp8opacity =  interpolateAlpha(current, 15,    20,    15, 255);
            const amp9opacity =  interpolateAlpha(current, 20,    25,    15, 255);
            const amp10opacity = interpolateAlpha(current, 25,    30,    15, 255);
            const amp11opacity = interpolateAlpha(current, 30,    35,    15, 255);

            amp1.color = compileAlpha(color, amp1opacity);
            amp2.color = compileAlpha(color, amp2opacity);
            amp3.color = compileAlpha(color, amp3opacity);
            amp5.color = compileAlpha(color, amp5opacity);
            amp6.color = compileAlpha(color, amp6opacity);
            amp7.color = compileAlpha(color, amp7opacity);
            amp8.color = compileAlpha(color, amp8opacity);
            amp9.color = compileAlpha(color, amp9opacity);
            amp10.color = compileAlpha(color, amp10opacity);
            amp11.color = compileAlpha(color, amp11opacity);*/

        }

        function onValuesSetupReceived(values, mask) {
            //currentGauge.maximumValue = Math.ceil(mMcConf.getParamDouble("l_current_max") / 5) * 5 * values.num_vescs
            //currentGauge.minimumValue = Math.ceil(mMcConf.getParamDouble("l_current_min") / 5) * 5 * values.num_vescs
            //currentGauge.minimumValue = -currentGauge.maximumValue
            //currentGauge.labelStep = Math.ceil(currentGauge.maximumValue / 20) * 5

            setCurrent(values.current_in);
            currentText.text = values.current_in;
            fuelMaskCanvas.value = values.battery_level;
            fuelMaskCanvas.requestPaint()
            if(values.battery_level < 0.2) {
                fuelELabel.color = Utility.getAppHexColor("tertiary1");
            }
            else {
                fuelELabel.color = Utility.getAppHexColor("lightText");
            }

            if(values.battery_level > 0.9) {
                fuelFLabel.color = "green";
            }
            else {
                fuelFLabel.color = Utility.getAppHexColor("lightText");
            }

            fuelLabel.text =  parseFloat(values.battery_level * 100.0).toFixed(0)

            const now = (new Date());
            let mins = now.getMinutes();
            if (mins < 10)
                mins = "0" + mins;
            let hours = now.getHours();
            if (hours < 10)
                hours = "0" + hours;
            clockText.text = `${hours}:${mins}`;
            clockTextBottom.text = `${hours}:${mins}`;

            var useImperial = VescIf.useImperialUnits()
            var fl = mMcConf.getParamDouble("foc_motor_flux_linkage")
            var impFact = useImperial ? 0.621371192 : 1.0

            var dist = values.tachometer_abs / 1000.0
            var wh_consume = values.watt_hours - values.watt_hours_charged
            var wh_km_total = wh_consume / dist

            speedValue.text = Math.round(values.speed * 3.6 * impFact)
            speedUnit.text = useImperial ? "mph" : "km/h"

            // odometer
            odoText.text = parseFloat((values.odometer * impFact) / 1000.0).toFixed(2);
            odoUnit.text = useImperial ? "mi" : "km";

            // trip
            tripText.text = parseFloat((values.tachometer_abs * impFact) / 1000.0).toFixed(2);
            tripUnit.text = useImperial ? "mi" : "km";

            // temp
            tempText.text = parseFloat(values.temp_mos).toFixed(1);
            tempUnit.text = "\u00B0C";

            // consumption
            consumptionText.text = parseFloat(wh_km_total / impFact).toFixed(1);
            consumptionUnit.text = useImperial ? "Wh/mi" : "Wh/km";

            // voltage
            voltageText.text = values.v_in;

            // range
            var range = parseFloat(values.battery_wh / (wh_km_total / impFact)).toFixed(2)
            rangeText.text = range == Infinity || range == "NaN" ? "∞ " : range;
            rangeUnit.text = useImperial ? "mi" : "km";

            /*var powerMax = Math.min(values.v_in * Math.min(mMcConf.getParamDouble("l_in_current_max"),
                                                           mMcConf.getParamDouble("l_current_max")),
                                    mMcConf.getParamDouble("l_watt_max")) * values.num_vescs
            var powerMaxRound = (Math.ceil(powerMax / 1000.0) * 1000.0)

            if (Math.abs(powerGauge.maximumValue - powerMaxRound) > 1.2) {
                powerGauge.maximumValue = powerMaxRound
                powerGauge.minimumValue = -powerMaxRound
            }

            powerGauge.value = (values.current_in * values.v_in)*/

            /*valText.text =
                    "mAh Out  : " + parseFloat(values.amp_hours * 1000.0).toFixed(1) + "\n" +
                    "mAh In   : " + parseFloat(values.amp_hours_charged * 1000.0).toFixed(1)

            odometerValue = values.odometer

            var l1Txt = useImperial ? "mi Trip : " : "km Trip : "
            var l2Txt = useImperial ? "Wh/mi   : " : "Wh/km   : "

            valText2.text =
                l1Txt + parseFloat((values.tachometer_abs * impFact) / 1000.0).toFixed(3) + "\n" +
                l2Txt + parseFloat(wh_km_total / impFact).toFixed(1)*/
        }

        function onCustomAppDataReceived(data) {
            var dv = new DataView(data, 0);
            const scooterOff = dv.getInt8(0) == 1;
            const scooterLocked = dv.getInt8(1) == 1;
            const speedMode = dv.getInt8(2);
            const lightState = dv.getInt8(3) == 1;
            const secret = dv.getInt8(4) == 1;
            // console.log(dv.getInt8(0), dv.getInt8(1), dv.getInt8(2), dv.getInt8(3), dv.getInt8(4));

            let gearStr = "";

            if(speedMode == 1) {
                gearStr = "D";
            }
            else if(speedMode == 2) {
                gearStr = "D";
            }
            else if(speedMode == 4) {
                gearStr = "S";
            }

            if (scooterLocked) {
                gearStr = "P";
                lockText.visible = true;
            }
            else {
                lockText.visible = false;
            }

            if (scooterOff) {
                gearStr = "N";
                offText.visible = true;
            }
            else {
                offText.visible = false;
            }

            gear.text = gearStr;

            if (secret) {
                mode.text = "DEMON";
                mode.color = Utility.getAppHexColor("red");
            }
            else if(speedMode == 2) {
                mode.text = "WALK";
                mode.color = "green";
            }
            else {
                mode.text = "NORMAL";
                mode.color = Utility.getAppHexColor("tertiary2");
            }

            if(lightState) {
                light.visible = true;
            }
            else {
                light.visible = false;
            }
        }
        // (send-data (list off lock speedmode light unlock))

        function onGnssRx(values, mask) {
            var useImperial = VescIf.useImperialUnits()
            var impFact = useImperial ? 0.621371192 : 1.0
            speedGnss.text = "(" + Math.round(values.speed * 3.6 * impFact) + ")"
        }
    }
}
