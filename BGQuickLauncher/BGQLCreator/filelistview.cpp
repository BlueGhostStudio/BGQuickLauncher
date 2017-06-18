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

#include "filelistview.h"

FileListView::FileListView (QWidget* parent)
    : QTreeView (parent)
{
    FileModel.setNameFilters (QStringList { "*.qml", "*.png", "*.jpg", "*.gif", "*.js", "qmldir" });
    FileModel.setNameFilterDisables (false);
    setModel (NULL);
}

void FileListView::setRootPath(const QString& p)
{
    if (p.isEmpty ())
        setModel (NULL);
    else {
        setModel (&FileModel);

        setHeaderHidden (true);
        setColumnHidden (1, true);
        setColumnHidden (2, true);
        setColumnHidden (3, true);
        setCurrentIndex (QModelIndex ());

        FileModel.setRootPath (p);
        setRootIndex (FileModel.index (p));
    }
}

QString FileListView::selPath() const
{
    return filePath (selectionModel ()->currentIndex ());
}

QString FileListView::filePath (const QModelIndex& index) const
{
    return FileModel.filePath (index);
}

QString FileListView::selDir() const
{
    QModelIndex index = selectionModel ()->currentIndex ();
    if (FileModel.isDir (index))
        return FileModel.filePath (index);
    else
        return FileModel.filePath (FileModel.parent (index));
}

bool FileListView::removeSelect()
{
    QModelIndex index = selectionModel ()->currentIndex ();
    if (FileModel.isDir (index))
        return FileModel.rmdir (index);
    else
        return FileModel.remove (index);
}
