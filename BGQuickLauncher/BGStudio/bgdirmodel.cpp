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

#include "bgdirmodel.h"
#include <QDebug>

BGDirModel::BGDirModel(QObject *parent)
    : QObject(parent), DirWatch (parent), Filter (QDir::NoFilter)
{
    QObject::connect (&DirWatch, &QFileSystemWatcher::directoryChanged,
                      this, &BGDirModel::fileListChanged);
}

QUrl BGDirModel::dir() const
{
    return Dir;
}

QVariantList BGDirModel::fileList() const
{
    return File.fileList (Dir, NameFilter, Filter);
}

void BGDirModel::setDir(const QUrl& url)
{
    QString dirStr = url.toString (QUrl::PreferLocalFile);
    if (!QFileInfo (dirStr).isDir ()) {
        qWarning () << "Path not dir";
        return;
    }

    DirWatch.removePaths (DirWatch.directories ());
    DirWatch.removePaths (DirWatch.files ());
    DirWatch.addPath (dirStr);

    Dir = url;
    dirChanged ();
    fileListChanged ();
}

QStringList BGDirModel::nameFilter() const
{
    return NameFilter;
}

void BGDirModel::setNameFilter(const QStringList& nf)
{
    NameFilter = nf;
    nameFilterChanged ();
    fileListChanged ();
}

int BGDirModel::filter() const
{
    return Filter;
}

void BGDirModel::setFilter(int f)
{
    Filter = f;
    filterChanged ();
    fileListChanged ();
}
