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

#ifndef BGDIRMODEL_H
#define BGDIRMODEL_H

#include <QObject>
#include <QFileSystemWatcher>
#include "bgfile.h"

class BGDirModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl dir READ dir WRITE setDir NOTIFY dirChanged)
    Q_PROPERTY(QVariantList fileList READ fileList NOTIFY fileListChanged)
    Q_PROPERTY(QStringList nameFilter READ nameFilter WRITE setNameFilter NOTIFY nameFilterChanged)
    Q_PROPERTY(int filter READ filter WRITE setFilter NOTIFY filterChanged)

public:
    explicit BGDirModel(QObject *parent = 0);

    QUrl dir () const;
    QVariantList fileList () const;
    void setDir (const QUrl& url);
    QStringList nameFilter () const;
    void setNameFilter (const QStringList& nf);
    int filter () const;
    void setFilter (int f);

signals:
    void dirChanged ();
    void fileListChanged ();
    void nameFilterChanged ();
    void filterChanged ();

public slots:

private:
    BGFile File;

    QFileSystemWatcher DirWatch;
    QUrl Dir;
    QStringList NameFilter;
    int Filter;
};

#endif // BGDIRMODEL_H
