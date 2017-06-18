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

#include <QDebug>
#include <QComboBox>
#include <QLineEdit>
#include "addprjfiledlg.h"

AddPrjFileDlg::AddPrjFileDlg(const QString& path, QWidget *parent) :
    QDialog(parent)
{
    setupUi(this);

    LEPath->setText (path);
    QObject::connect (CBType, static_cast<void(QComboBox::*)(int)>(&QComboBox::currentIndexChanged), [=](int index) {
        if (index == 2) {
            LEFileName->setText ("qmldir");
            LEFileName->setEnabled (false);
        } else
            LEFileName->setEnabled (true);
    });
}

QString AddPrjFileDlg::fileName() const
{
    return LEFileName->text ();
}

int AddPrjFileDlg::fileType() const
{
    return CBType->currentIndex ();
}

QString AddPrjFileDlg::path() const
{
    return LEPath->text ();
}
