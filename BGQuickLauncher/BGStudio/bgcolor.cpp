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

#include <QDebug>
#include "bgcolor.h"

BGColor::BGColor(QObject *parent) : QObject(parent)
{

}

QColor BGColor::contrast(const QColor& color, qreal factor)
{
    return QColor::fromHsv (color.hsvHue (), color.hsvSaturation (), contrastValue (color, factor),
                            color.alpha ());
}

QColor BGColor::contrast(const QColor& color1, const QColor& color2, qreal factor)
{
    return QColor::fromHsv (color1.hsvHue (), color1.hsvSaturation (), contrastValue (color2, factor),
                            color1.alpha ());
}

int BGColor::contrastValue(const QColor& color, qreal factor)
{
    int value = color.value ();

    if (value < 127) {
        value += 255 * factor;
        if (value > 255) value = 255;
    } else {
        value -= 255 * factor;
        if (value < 0) value = 0;
    }

    return value;
}

QObject* BGColor_singletontype_provider(QQmlEngine*, QJSEngine*)
{
    return new BGColor;
}
