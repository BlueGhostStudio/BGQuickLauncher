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

#ifndef BGQLCOMMON_H
#define BGQLCOMMON_H
#include "launcher.h"
#include <QQmlEngine>

extern QString rootPath;
extern QString appsPath;
extern QString dataPath;
extern QString modulesPath;
extern QString shellPath;
extern QString pluginsPath;
extern QString settingPath;

void initialEnvironment (QQmlEngine* engine);

#endif // BGQLCOMMON_H
