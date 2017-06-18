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

#ifndef PROJECTPROPERTYGROUPBOX_H
#define PROJECTPROPERTYGROUPBOX_H

#include "ui_projectpropertygroupbox.h"

class ProjectPropertyGroupBox : public QGroupBox, private Ui::ProjectPropertyGroupBox
{
    Q_OBJECT

public:
    explicit ProjectPropertyGroupBox(QWidget *parent = 0);
    void setTitle (const QString& t);
    void setDescription (const QString& d);
    void setIconSrc (const QString& i);
    void setPrjRootPath (const QString& path);
    void setCategory (const QString& cate);
    QString title () const;
    QString description () const;
    QString iconSrc () const;
    QString category () const;

private:
    QString PrjRootPath;
};

#endif // PROJECTPROPERTYGROUPBOX_H
