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

#include <QComboBox>
#include <QLineEdit>
#include <QPushButton>
#include "newprojectdialog.h"

NewProjectDialog::NewProjectDialog(QWidget *parent) :
    QDialog(parent)
{
    setupUi(this);
    /*QObject::connect (PBIconSrcSel, &QPushButton::clicked, [=] () {
        LEIconSrc->setText (QFileDialog::getOpenFileName(this, tr("Open File"),
                                                          "/home",
                                                          tr("Images (*.png *.gif *.jpg)")));
    });*/
}

int NewProjectDialog::prjType() const
{
    return CBType->currentIndex ();
}

QString NewProjectDialog::prjName() const
{
    return LEPrjName->text ();
}

QString NewProjectDialog::description() const
{
    return PPGBProperty->description ();
}

QString NewProjectDialog::title() const
{
    return PPGBProperty->title ();
}

QString NewProjectDialog::iconSrc() const
{
    return PPGBProperty->iconSrc ();
}

QString NewProjectDialog::category() const
{
    return PPGBProperty->category ();
}
