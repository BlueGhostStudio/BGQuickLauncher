/*****************************************************************************
 *   BGControls - Quick/Qml module, Controls.
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

#include "bgcontrols_plugin.h"
#include "bgtextedit.h"

#include <qqml.h>
#include <QDebug>

void BGControlsPlugin::registerTypes(const char *uri)
{
    // @uri BGControls
    qmlRegisterType<BGTextEdit>(uri, 1, 0, "BGTextEditProcess");
}

