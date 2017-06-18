/*****************************************************************************
 *   BGStudio - Quick/Qml model, mis fun writer by BGStudio
 *   Copyright (C) 2017  Shubin Hu, SeekAWAyOut@gmail.com
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

#include "bgstudio_plugin.h"
#include "bgfile.h"
#include "bgcmd.h"
#include "bgsettings.h"
#include "bgcolor.h"
#include "bgdirmodel.h"
#include "bglauncherlog.h"
#include "bgclipboard.h"
#include "bgevent.h"

#include <qqml.h>
#include <QQmlEngine>

void BGFilePlugin::registerTypes(const char *uri)
{
    // @uri BGStudio
    //qmlRegisterType<BGFile>(uri, 1, 0, "BGFile");
    qmlRegisterSingletonType < BGFile > (uri, 1, 0,
                                         "BGFile", BGFile_singletontype_provider);
    qmlRegisterSingletonType < BGCmd > (uri, 1, 0,
                                         "BGCmd", BGCmd_singletontype_provider);
    qmlRegisterSingletonType < BGSettings > (uri, 1, 0,
                                         "BGSettings", BGSettings_singletontype_provider);
    qmlRegisterSingletonType < BGColor > (uri, 1, 0,
                                         "BGColor", BGColor_singletontype_provider);
    qmlRegisterType < BGDirModel > (uri, 1, 0, "BGDirModel");
    qmlRegisterSingletonType < BGLauncherLog > (uri, 1, 0,
                                                "BGLauncherLog", BGLauncherLog_singletontype_provider);
    qmlRegisterType < BGFileHandle > ();
    qmlRegisterSingletonType < BGClipBoard > (uri, 1, 0,
                                         "BGClip", BGClipBoard_singletontype_provider);
    qmlRegisterSingletonType < BGEvent > (uri, 1, 0,
                                         "BGEvent", BGEvent_singletontype_provider);

    qmlRegisterUncreatableType < BGFile > (uri, 1, 0, "BGFile", "standardpath enum");
    qmlRegisterUncreatableType < BGEvent > (uri, 1, 0, "BGEvent", "BGEvent enum");
}

