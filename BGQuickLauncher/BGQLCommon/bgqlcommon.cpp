/*****************************************************************************
 *   Common library of BGQuickLauncher and BGQLCreator
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

#include "bgqlcommon.h"
#include <QStandardPaths>
#include <QQmlContext>
#include <QCoreApplication>

QString rootPath = QStandardPaths::standardLocations (
                       QStandardPaths::DocumentsLocation).first ()
                   + "/BGQuickLauncher/";
QString appsPath = rootPath + "apps/";
QString dataPath = rootPath + "data/";
QString modulesPath = rootPath + "modules/";
QString shellPath = rootPath  + "Shell/";
QString pluginsPath = rootPath + "plugins/";
QString settingPath;

void initialEnvironment(QQmlEngine* engine)
{
    settingPath = QStandardPaths::standardLocations (
                      QStandardPaths::GenericConfigLocation).first () + "/BGQuickLauncher";
    qmlRegisterType < Instance > ();
    qmlRegisterType < Launcher > ("BGQuickLauncher", 1,0, "Launcher");

    engine->rootContext ()->setContextProperty ("rootPath", rootPath);
    engine->rootContext ()->setContextProperty ("appsPath", appsPath);
    engine->rootContext ()->setContextProperty ("dataPath", dataPath);
    engine->rootContext ()->setContextProperty ("modulesPath", modulesPath);
    engine->rootContext ()->setContextProperty ("shellPath", shellPath);
    //engine->rootContext ()->setContextProperty ("settingPath", settingPath);

    engine->addImportPath (":/");
    pluginsPath = QStandardPaths::standardLocations (QStandardPaths::DataLocation).first () + "/plugins";

    if (!QDir().exists (pluginsPath))
        QDir().mkpath (pluginsPath);

    engine->addImportPath (modulesPath);
    engine->addPluginPath (pluginsPath);
}
