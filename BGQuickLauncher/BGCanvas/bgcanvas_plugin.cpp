/*****************************************************************************
 *   BGCanvas - Quick/Qml module, draw graphics
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

#include "bgcanvas_plugin.h"
#include "bgcanvas.h"

#include <qqml.h>

void BGCanvasPlugin::registerTypes(const char *uri)
{
    // @uri BGCanvas
    qmlRegisterType<BGCanvas>(uri, 1, 0, "BGCanvas");
    qmlRegisterType<BGPathBase>(uri, 1, 0, "BGPathBase");
    qmlRegisterType<BGRect>(uri, 1, 0, "BGRect");
    qmlRegisterType<BGEllipse>(uri, 1, 0, "BGEllipse");
    qmlRegisterType<BGRoundedRect>(uri, 1, 0, "BGRoundedRect");
    qmlRegisterType<BGPath>(uri, 1, 0, "BGPath");
    qmlRegisterType<BGPathElemBase>(uri, 1, 0, "BGPathElemBase");
    qmlRegisterType<BGLineTo>(uri, 1, 0, "BGLineTo");
    qmlRegisterType<BGArcTo>(uri, 1, 0, "BGArcTo");
    qmlRegisterType<BGQuadTo>(uri, 1, 0, "BGQuadTo");
    qmlRegisterType<BGCubicTo>(uri, 1, 0, "BGCubicTo");
}
