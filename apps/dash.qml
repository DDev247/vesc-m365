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

import QtQuick 2.5
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

    property Commands mCommands: VescIf.commands()
    property ConfigParams mMcConf: VescIf.mcConfig()
    property int odometerValue: 0
    property double efficiency_lpf: 0
    property bool isHorizontal: rtData.width > rtData.height

    property int gaugeSize: (isHorizontal ? Math.min((height - valMetrics.height * 4)/1.3 - 30, width / 2.65 - 10) :
                                            Math.min(width / 1.4, (height - valMetrics.height * 4) / 2.3 - 10))
    property int gaugeSize2: gaugeSize * 0.575
    property int gaugeSizeConfig: Math.min(width / 2 - 10,
                                     (height - valMetrics.height * 10) /
                                     (isHorizontal ? 1 : 2) - (isHorizontal ? 30 : 20))

    Component.onCompleted: {
        mCommands.emitEmptySetupValues()
    }

    // Make background slightly darker
    Rectangle {
        anchors.fill: parent
        color: {color = Utility.getAppHexColor("darkBackground")}
    }

    PageIndicator {
        count: dashboardSwipeView.count
        currentIndex: dashboardSwipeView.currentIndex
        anchors.right: parent.right
        width:25
        anchors.verticalCenter: parent.verticalCenter
        rotation: 90
        z:2
    }

    SwipeView {
        id: dashboardSwipeView
        enabled: true
        clip: true
        currentIndex: 0
        anchors.fill:parent
        orientation: Qt.Vertical

        Page {
            id: dashboardMainPage

            GridLayout {
                anchors.fill: parent
                columns: isHorizontal ? 2 : 1
                columnSpacing: 0
                rowSpacing: 0
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: gaugeSize2*1.1
                    color: "transparent"
                    CustomGauge {
                        id: currentGauge
                        width:gaugeSize2
                        height:gaugeSize2
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -0.675*gaugeSize2
                        anchors.verticalCenterOffset: 0.1*gaugeSize2
                        minimumValue: -30
                        maximumValue: 50
                        labelStep: maximumValue > 60 ? 20 : 10
                        unitText: "A"
                        typeText: "Current"
                        precision: 1
                        minAngle: -210
                        maxAngle: 15
                        nibColor: value <= maximumValue && value >= minimumValue ? Utility.getAppHexColor("tertiary1") : Utility.getAppHexColor("red")

                        Behavior on nibColor {
                            ColorAnimation {
                                duration: 1000;
                                easing.type: Easing.InOutSine
                                easing.overshoot: 3
                            }
                        }
                        CustomGauge {
                            id: dutyGauge
                            width: gaugeSize2
                            height: gaugeSize2
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: gaugeSize2*1.35
                            maximumValue: 100
                            minimumValue: -50
                            minAngle: 210
                            maxAngle: -15
                            isInverted: -1
                            labelStep: 25
                            value: 0
                            unitText: "%"
                            typeText: "Duty"
                            nibColor: Utility.getAppHexColor("tertiary3")
                            CustomGauge {
                                id: powerGauge
                                width: gaugeSize2*1.05
                                height: gaugeSize2*1.05
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: -0.675*gaugeSize2
                                anchors.verticalCenterOffset: -0.1*gaugeSize2
                                maximumValue: 10000
                                minimumValue: -10000
                                tickmarkScale: 0.01
                                //tickmarkScale: 0.001
                                //tickmarkSuffix: "k"
                                labelStep: 500
                                value: 0
                                unitText: "W•100"
                                typeText: "Power"
                                nibColor: Utility.getAppHexColor("tertiary2")

                                Text {
                                    id: tempText
                                    anchors.centerIn: parent
                                    anchors.verticalCenterOffset: 0.7*(gaugeSize2)/2
                                    font.pixelSize: gaugeSize2/12.0
                                    text: "26\u00B0C"
                                    color: {color = Utility.getAppHexColor("lightText")}
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: gaugeSize
                    color: "transparent"
                    Layout.rowSpan: isHorizontal ? 2:1
                    CustomGauge {
                        id: speedGauge
                        width:parent.height
                        height:parent.height
                        anchors.centerIn: parent
                        //anchors.horizontalCenterOffset: (width/4 - gaugeSize2)/2
                        minimumValue: 0
                        maximumValue: 60
                        minAngle: -125
                        maxAngle: 125
                        labelStep: maximumValue > 60 ? 20 : 10
                        value: 0
                        unitText: VescIf.useImperialUnits() ? "mph" : "km/h"
                        typeText: "Speed"

                        nibColor: Utility.getAppHexColor("lightAccent")
                        Behavior on nibColor {
                            ColorAnimation {
                                duration: 2000;
                                easing.type: Easing.InOutSine
                                easing.overshoot: 3
                            }
                        }

                        Button {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 0.7*(gaugeSize)/2
                            height: parent.height*0.15
                            width: parent.width*0.23

                            background: Rectangle {
                                opacity: 0
                            }

                            onClicked: {
                                commandTimer.running = !commandTimer.running
                            }
                            contentItem: Image {
                                height: parent.parent.height*0.05
                                anchors.fill: parent
                                antialiasing: true
                                opacity: commandTimer.running ? 0.4 : 0.1
                                fillMode: Image.PreserveAspectFit
                                source: {source = "qrc" + Utility.getThemePath() + "icons/vesc-96.png"}
                                //anchors.horizontalCenterOffset: (gaugeSize)/3.25 + gaugeSize2/2
                            }
                        }

                        Text {
                            id: odoText
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 0.5*(gaugeSize)/2
                            font.pixelSize: gaugeSize/18.0
                            text: "5.0KM"
                            color: {color = Utility.getAppHexColor("lightText")}
                        }
                    }
                }


                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: gaugeSize2*1.1
                    color: "transparent"
                    CustomGauge {
                        id: batCurrentGauge
                        width:gaugeSize2
                        height:gaugeSize2
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -0.675*gaugeSize2
                        anchors.verticalCenterOffset: -0.1*gaugeSize2
                        minimumValue: -10
                        maximumValue: 30
                        labelStep: maximumValue > 60 ? 20 : 10
                        unitText: "A"
                        typeText: "Bat. Cur."
                        precision: 1
                        minAngle: -195
                        maxAngle: 30
                        nibColor: value <= maximumValue && value >= minimumValue ? Utility.getAppHexColor("tertiary1") : Utility.getAppHexColor("red")

                        Behavior on nibColor {
                            ColorAnimation {
                                duration: 1000;
                                easing.type: Easing.InOutSine
                                easing.overshoot: 3
                            }
                        }
                        CustomGauge {
                            id: batteryGauge
                            width: gaugeSize2
                            height: gaugeSize2
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: gaugeSize2*1.35
                            minAngle: 195
                            maxAngle: -30
                            isInverted: -1
                            minimumValue: 0
                            maximumValue: 100
                            value: 95
                            unitText: "%"
                            typeText: "Battery"
                            nibColor: value >= 50 ? "green" : (value >= 20 ? Utility.getAppHexColor("orange") : Utility.getAppHexColor("red"))

                            Behavior on nibColor {
                                ColorAnimation {
                                    duration: 1000;
                                    easing.type: Easing.InOutSine
                                    easing.overshoot: 3
                                }
                            }
                            CustomGauge {
                                id: voltageGauge
                                width: gaugeSize2*1.05
                                height: gaugeSize2*1.05
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: -0.675*gaugeSize2
                                anchors.verticalCenterOffset: 0.1*gaugeSize2
                                maximumValue: 42
                                minimumValue: 30
                                labelStep: 1
                                precision: 2
                                value: 40
                                unitText: "V"
                                typeText: "Voltage"
                                nibColor: value >= 38.0 ? (value <= maximumValue ? "green" : Utility.getAppHexColor("red")) : (value >= 34 ? Utility.getAppHexColor("orange") : Utility.getAppHexColor("red"))

                                Behavior on nibColor {
                                    ColorAnimation {
                                        duration: 1000;
                                        easing.type: Easing.InOutSine
                                        easing.overshoot: 3
                                    }
                                }

                                Text {
                                    id: rangeText
                                    anchors.centerIn: parent
                                    anchors.verticalCenterOffset: 0.7*(gaugeSize2)/2
                                    font.pixelSize: gaugeSize2/12.0
                                    text: "26KM"
                                    color: {color = Utility.getAppHexColor("lightText")}
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: textRect
                    color: Utility.getAppHexColor("darkBackground")
                    Layout.fillWidth: true
                    Layout.preferredHeight: valMetrics.height * 2 + 20
                    Layout.alignment: Qt.AlignBottom
                    Layout.columnSpan: isHorizontal ? 2 : 1

                    Rectangle {
                        id: borderRect
                        anchors.top: parent.top
                        width: parent.width
                        height: 2
                        color: Utility.getAppHexColor("lightAccent")

                        Behavior on color {
                            ColorAnimation {
                                duration: 2000;
                                easing.type: Easing.InOutSine
                                easing.overshoot: 3
                            }
                        }
                    }

                    Text {
                        id: valText
                        color: Utility.getAppHexColor("lightText")
                        text: VescIf.getConnectedPortName()
                        font.family: "DejaVu Sans Mono"
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 10
                    }

                    Text {
                        id: valText2
                        color: Utility.getAppHexColor("lightText")
                        text: VescIf.getConnectedPortName()
                        font.family: "DejaVu Sans Mono"
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 10
                    }

                    TextMetrics {
                        id: valMetrics
                        font: valText.font
                        text: valText.text
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            var impFact = VescIf.useImperialUnits() ? 0.621371192 : 1.0
                            odometerBox.realValue = odometerValue*impFact/1000.0
                            tripDialog.open()
                        }

                        Dialog {
                            id: tripDialog
                            modal: true
                            focus: true
                            width: parent.width - 20
                            height: Math.min(implicitHeight, parent.height - 60)
                            closePolicy: Popup.CloseOnEscape

                            Overlay.modal: Rectangle {
                                color: "#AA000000"
                            }

                            x: 10
                            y: Math.max((parent.height - height) / 2, 10)
                            parent: dialogParent
                            standardButtons: Dialog.Ok | Dialog.Cancel
                            onAccepted: {
                                var impFact = VescIf.useImperialUnits() ? 0.621371192 : 1.0
                                mCommands.setOdometer(Math.round(odometerBox.realValue*1000/impFact))
                            }

                            ColumnLayout {
                                id: scrollColumn
                                anchors.fill: parent

                                ScrollView {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    clip: true
                                    contentWidth: parent.width
                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        Text {
                                            color: Utility.getAppHexColor("lightText")
                                            text: "Odometer"
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            Layout.fillWidth: true
                                            font.pointSize: 12
                                        }

                                        DoubleSpinBox {
                                            id: odometerBox
                                            decimals: 2
                                            realFrom: 0.0
                                            realTo: 20000000
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                } // Rectangle.textRect
            } // GridLayout
        } // Page.dashboardMainPage

        Page {
            id: dashboardRtStateActionsPage
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 5

                ColumnLayout {
                    // Layout.fillWidth: true
                    // Layout.fillHeight: true
                    width: parent.width
                    height: parent.height

                    Text {
                        id: statusText
                        color: Utility.getAppHexColor("lightText")
                        text: "Headlight: Off\nLocked: False\nMode: Sport\nSecret: On"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        font.pointSize: 12
                    }

                    Rectangle {
                        id: stateActionsBorder
                        Layout.alignment: Qt.AlignHCenter
                        width: 100
                        height: 2
                        color: Utility.getAppHexColor("lightAccent")

                        Behavior on color {
                            ColorAnimation {
                                duration: 2000;
                                easing.type: Easing.InOutSine
                                easing.overshoot: 3
                            }
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        text: "SHUTDOWN"
                        onClicked: function () {
                            var dataTx = new ArrayBuffer(2)
                            var dvTx = new DataView(dataTx)
                            dvTx.setUint16(0, 0xDD01);
                            mCommands.sendCustomAppData(dataTx)
                        }
                    }
                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        text: "TOGGLE SECRET"
                        onClicked: function () {
                            var dataTx = new ArrayBuffer(2)
                            var dvTx = new DataView(dataTx)
                            dvTx.setUint16(0, 0xDD02);
                            mCommands.sendCustomAppData(dataTx)
                        }
                    }
                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        text: "TOGGLE LOCK"
                        onClicked: function () {
                            var dataTx = new ArrayBuffer(2)
                            var dvTx = new DataView(dataTx)
                            dvTx.setUint16(0, 0xDD03);
                            mCommands.sendCustomAppData(dataTx)
                        }
                    }
                }
            } // ColumnLayout
        } // Page.dashboardRtConfigPage
    } // SwipeView

    Timer {
        id: commandTimer
        running: false
        repeat: true
        interval: 100

        onTriggered: {
            //mCommands.getValues()
            mCommands.getValuesSetup()
        }
    }

    Connections {
        target: mMcConf

        function onUpdated() {
            //configFwkCurrentGauge.value = mMcConf.getParamDouble("foc-fw-current-max");
            console.log("upd");
            console.log(mMcConf, mMcConf.getParamDouble("foc-fw-current-max"));
        }
    }

    Connections {
        id: commandsUpdate
        target: mCommands

        function onValuesSetupReceived(values, mask) {
            currentGauge.labelStep = Math.ceil(currentGauge.maximumValue / 20) * 5

            batCurrentGauge.value = values.current_in
            currentGauge.value = values.current_motor
            dutyGauge.value = values.duty_now * 100.0
            batteryGauge.value = values.battery_level * 100.0
            voltageGauge.value = values.v_in

            var useImperial = VescIf.useImperialUnits()
            var fl = mMcConf.getParamDouble("foc_motor_flux_linkage")
            var rpmMax = (values.v_in * 60.0) / (Math.sqrt(3.0) * 2.0 * Math.PI * fl)
            var speedFact = ((mMcConf.getParamInt("si_motor_poles") / 2.0) * 60.0 *
                             mMcConf.getParamDouble("si_gear_ratio")) /
                             (mMcConf.getParamDouble("si_wheel_diameter") * Math.PI)
            var speedMax = 3.6 * rpmMax / speedFact
            var impFact = useImperial ? 0.621371192 : 1.0
            var speedMaxRound = (Math.ceil((speedMax * impFact) / 10.0) * 10.0)

            var dist = values.tachometer_abs / 1000.0
            var wh_consume = values.watt_hours - values.watt_hours_charged
            var wh_km_total = wh_consume / dist

            if (Math.abs(speedGauge.maximumValue - speedMaxRound) > 6.0) {
                speedGauge.maximumValue = speedMaxRound
                speedGauge.minimumValue = 0
            }

            speedGauge.value = values.speed * 3.6 * impFact
            speedGauge.unitText = useImperial ? "mph" : "km/h"

            odoText.text = parseFloat((values.odometer * impFact) / 1000.0).toFixed(odometerBox.decimals) + (useImperial ? "MI" : "KM")
            tempText.text = parseFloat(values.temp_mos).toFixed(1) + "\u00B0C";
            var range = parseFloat(values.battery_wh / (wh_km_total / impFact)).toFixed(2)
            rangeText.text = (range == Infinity || range == "NaN" ? "∞ " : range) + (useImperial ? "MI" : "KM")

            var powerMax = Math.min(values.v_in * Math.min(mMcConf.getParamDouble("l_in_current_max"),
                                                           mMcConf.getParamDouble("l_current_max")),
                                    mMcConf.getParamDouble("l_watt_max")) * values.num_vescs
            var powerMaxRound = (Math.ceil(powerMax / 1000.0) * 1000.0)

            if (Math.abs(powerGauge.maximumValue - powerMaxRound) > 1.2) {
                powerGauge.maximumValue = powerMaxRound
                powerGauge.minimumValue = -powerMaxRound
            }

            powerGauge.value = (values.current_in * values.v_in)

            valText.text =
                    "mAh Out  : " + parseFloat(values.amp_hours * 1000.0).toFixed(1) + "\n" +
                    "mAh In   : " + parseFloat(values.amp_hours_charged * 1000.0).toFixed(1)

            odometerValue = values.odometer

            var l1Txt = useImperial ? "mi Trip : " : "km Trip : "
            var l2Txt = useImperial ? "Wh/mi   : " : "Wh/km   : "

            valText2.text =
                l1Txt + parseFloat((values.tachometer_abs * impFact) / 1000.0).toFixed(3) + "\n" +
                l2Txt + parseFloat(wh_km_total / impFact).toFixed(1)
        }

        function onCustomAppDataReceived(data) {
            var dv = new DataView(data, 0);
            const scooterOff = dv.getInt8(0) == 1;
            const scooterLocked = dv.getInt8(1) == 1;
            const speedMode = dv.getInt8(2);
            const lightState = dv.getInt8(3) == 1;
            const secret = dv.getInt8(4) == 1;

            var modeStr = "";
            switch(speedMode) {
                case 1: modeStr = "Eco"; break;
                case 2: modeStr = "Drive"; break;
                case 4: modeStr = "Sport"; break;
            }

            const color = secret ? Utility.getAppHexColor("red") : Utility.getAppHexColor("lightAccent");
            borderRect.color = color;
            stateActionsBorder.color = color; 
            speedGauge.nibColor = color;
            speedGauge.update();

            statusText.text = `Headlight: ${lightState ? "On":"Off"}\nLocked: ${scooterLocked ? "True":"False"}\nMode: ${modeStr}\nSecret: ${secret ? "On":"Off"}`;
        }
    }
}
