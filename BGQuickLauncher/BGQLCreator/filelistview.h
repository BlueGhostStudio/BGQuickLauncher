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

#ifndef FILELISTVIEW_H
#define FILELISTVIEW_H

#include <QTreeView>
#include <QFileSystemModel>

class FileListView : public QTreeView
{
    Q_OBJECT

public:
    explicit FileListView (QWidget* parent = 0);

    void setRootPath (const QString& p);
    QString selPath () const;
    QString filePath (const QModelIndex& index) const;
    QString selDir () const;
    bool removeSelect ();

private:
    QFileSystemModel FileModel;
};

#endif // FILELISTVIEW_H
