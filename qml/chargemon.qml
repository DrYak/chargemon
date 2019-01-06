/*
 * Charge monitor (C) 2014-2019 Kimmo Lindholm
 * LICENSE MIT
 */
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.chargemon 1.0
import "pages"

ApplicationWindow
{

    id: chargemonitor

    property string coverActionLeftIcon: writelog ? "image://theme/icon-cover-cancel" :
                                                    (coverRefresh ?"image://theme/icon-cover-pause" :
                                                                    "image://theme/icon-cover-play")
    property string coverActionRightIcon: writelog ? "" : "image://theme/icon-cover-refresh"
    property bool coverRefresh: false
    property bool writelog : false

    onWritelogChanged:
    {
        if (writelog)
        {
            coverRefresh = false
        }
    }

    initialPage: Qt.resolvedUrl("pages/Chargemon.qml")

    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    function coverActionLeft()
    {
        if (writelog)
        {
            writelog = false
        }
        else if (!refreshTimer.running)
        {
            coverRefresh = true
        }
        else
        {
            coverRefresh = false
        }
    }

    function coverActionRight()
    {
        if (!refreshTimer.running && !writelog)
        {
            cmon.update()
        }
    }

    Messagebox
    {
        id: messagebox
    }

    Timer
    {
        id: refreshTimer
        interval: 500
        running: coverRefresh && !writelog && cmon.coverStatus === 2
        repeat: true
        onTriggered: cmon.update()
    }

    Cmon
    {
        id: cmon
        onThisDeviceIsNotSupported: messagebox.showMessage("This device is not supported!")
    }

}


