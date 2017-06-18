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

#include "projectpropertygroupbox.h"
#include <QLineEdit>
#include <QTextEdit>
#include <QPushButton>
#include <QFileDialog>

ProjectPropertyGroupBox::ProjectPropertyGroupBox(QWidget *parent) :
    QGroupBox(parent), PrjRootPath (QDir::homePath ())
{
    setupUi(this);

    QObject::connect (PBIconSrcSel, &QPushButton::clicked, [=] () {
        LEIconSrc->setText (QFileDialog::getOpenFileName(this, tr("Open File"),
                                                         PrjRootPath,
                                                         tr("Images (*.png *.gif *.jpg)")));
    });
}

void ProjectPropertyGroupBox::setTitle(const QString& t)
{
    LETitle->setText (t);
}

void ProjectPropertyGroupBox::setDescription(const QString& d)
{
    TEDesc->setPlainText (d);
}

void ProjectPropertyGroupBox::setIconSrc(const QString& i)
{
    LEIconSrc->setText (i);
}

void ProjectPropertyGroupBox::setPrjRootPath(const QString& path)
{
    PrjRootPath = path;
}

void ProjectPropertyGroupBox::setCategory(const QString& cate)
{
    LECategory->setText (cate);
}

QString ProjectPropertyGroupBox::title() const
{
    return LETitle->text ();
}

QString ProjectPropertyGroupBox::description() const
{
    return TEDesc->toPlainText ();
}

QString ProjectPropertyGroupBox::iconSrc() const
{
    return LEIconSrc->text ();
}

QString ProjectPropertyGroupBox::category() const
{
    return LECategory->text ();
}
