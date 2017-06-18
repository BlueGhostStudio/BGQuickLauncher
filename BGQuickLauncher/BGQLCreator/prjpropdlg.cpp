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

#include <QSettings>
#include <QDebug>
#include <QFileInfo>
#include "prjpropdlg.h"

PrjPropDlg::PrjPropDlg(const QString& prjPath, QWidget *parent) :
    QDialog(parent), PrjRootPath (prjPath)
{
    setupUi(this);

    PPGBProperty->setPrjRootPath (prjPath);
    QSettings appSet (PrjRootPath + "/appProp", QSettings::IniFormat);
    PPGBProperty->setTitle (appSet.value ("title", QFileInfo(prjPath).fileName ()).toString ());
    PPGBProperty->setDescription (appSet.value ("description").toString ());
    PPGBProperty->setIconSrc (appSet.value ("iconSrc").toString ());
    PPGBProperty->setCategory (appSet.value ("category", "Default").toString ());
}

QString PrjPropDlg::description() const
{
    return PPGBProperty->description ();
}

QString PrjPropDlg::title() const
{
    return PPGBProperty->title ();
}

QString PrjPropDlg::iconSrc() const
{
    return PPGBProperty->iconSrc ();
}

QString PrjPropDlg::category() const
{
    return PPGBProperty->category ();
}


