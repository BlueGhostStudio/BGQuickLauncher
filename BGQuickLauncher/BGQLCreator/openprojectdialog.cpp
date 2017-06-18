/*****************************************************************************
 *   BGQLCreator - Develop IDE for BGQuickLauncher, for Quick/Qml
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

#include <bgqlcommon.h>
#include "prjlistview.h"

#include "openprojectdialog.h"

OpenProjectDialog::OpenProjectDialog(QWidget *parent) :
    QDialog(parent)
{
    setupUi(this);
    LVAppProjects->setRootPath (appsPath);
    LVModulesProjects->setRootPath (modulesPath);
    LVShellProjects->setRootPath (shellPath);
}

OpenProjectDialog::Which OpenProjectDialog::openWhich() const
{
    Which wh;
    switch (tabWidget->currentIndex ()) {
    case 0:
        wh = APPPRJ;
        break;
    case 1:
        wh = MODULEPRJ;
        break;
    case 2:
        wh = SHELLPRJ;
        break;
    }
    return wh;
}

QString OpenProjectDialog::prjPath() const
{
    switch (tabWidget->currentIndex ()) {
    case 0:
        return LVAppProjects->selPath ();
    case 1:
        return LVModulesProjects->selPath ();
    case 2:
        return LVShellProjects->selPath();
    }
    return "";
}
