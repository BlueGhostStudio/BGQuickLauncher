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

#include "bgfile.h"
#include <QFileInfo>
#include <QRegularExpression>
#include <QDateTime>
#include <QDebug>
#include <QQmlEngine>


BGFileHandle::BGFileHandle(const QString& fileName, QObject* parent)
    : QObject (parent), File (fileName)
{
    
}

bool BGFileHandle::open()
{
    return File.open (QIODevice::ReadWrite);
}

void BGFileHandle::close()
{
    File.close ();
}

bool BGFileHandle::seek(qint64 pos)
{
    return File.seek (pos);
}

qint64 BGFileHandle::pos() const
{
    return File.pos ();
}

QByteArray BGFileHandle::readAll()
{
    return File.readAll ();
}

QByteArray BGFileHandle::read(qint64 maxLen)
{
    return File.read (maxLen);
}

QVariantList BGFileHandle::readAllb()
{
    QVariantList r;
    foreach (char d, readAll ()) {
        r << d;
    }
    return r;
}

QVariantList BGFileHandle::readb(qint64 maxLen)
{
    QVariantList r;
    foreach (char d, read (maxLen)) {
        r << d;
    }
    return r;
}

qint64 BGFileHandle::write(const QByteArray& data)
{
    return File.write (data);
}

QFileDevice::FileError BGFileHandle::error() const
{
    return File.error ();
}

QString BGFileHandle::errorString() const
{
    return File.errorString ();
}

BGFile::BGFile(QObject* parent):
    QObject(parent)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);
}

BGFile::~BGFile()
{
}

QUrl BGFile::currentPath() const
{
    return CurrentPath;
}

void BGFile::chdir(const QUrl& url)
{
    CurrentPath = urlToPath (url);
    currentPathChanged ();
}

QByteArray
BGFile::readFile(const QUrl& fileUrl) const
{
    QString fileName = urlToPath (fileUrl);

    QFile file (fileName);
    QByteArray data;
    if (file.open (QIODevice::ReadOnly))
        data = file.readAll ();

    LastError = file.error ();
    LastErrorString = file.errorString ();
    file.close ();

    return data;
}

bool BGFile::writeFile(const QUrl& fileUrl, const QByteArray& data) const
{
    QString fileName = urlToPath (fileUrl);
    QFile file (fileName);
    if (file.open (QIODevice::WriteOnly))
        file.write (data);

    LastError = file.error ();
    LastErrorString = file.errorString ();
    file.close ();

    return LastError == QFileDevice::NoError;
}

bool BGFile::mv(const QUrl& sUrl, const QUrl& tUrl) const
{
    QString sp = urlToPath (sUrl);
    QString tp = urlToPath (tUrl);
    if (QFileInfo (tp).isDir ())
        tp += "/" + QFileInfo (sp).fileName ();

    return QFile::rename (sp, tp);
}

bool BGFile::cp(const QUrl& sUrl, const QUrl& tUrl) const
{
    QString sp = urlToPath (sUrl);
    QString tp = urlToPath (tUrl);
    if (QFileInfo (tp).isDir ())
        tp += "/" + QFileInfo (sp).fileName ();

    return QFile::copy (sp, tp);
}

bool BGFile::rm(const QUrl& url) const
{
    QString path = urlToPath (url);
    if (QFileInfo (path).isDir ())
        return rmpath (url);
    else
        return QFile::remove (urlToPath (url));
}

bool BGFile::mkpath(const QUrl& url) const
{
    return QDir().mkpath (urlToPath (url));
}

bool BGFile::rmpath(const QUrl& url) const
{
    return QDir().rmpath (urlToPath (url));
}

bool BGFile::exists(const QUrl& url) const
{
    return QFile::exists (urlToPath (url));
}

QVariantList BGFile::fileList(const QUrl& url, const QStringList& nameFilter, int filters/*bool noDotAndDotDot*/) const
{
    QVariantList result;
    QDir dir (urlToPath (url));
    foreach (QFileInfo fi, dir.entryInfoList (nameFilter, (QDir::Filters)filters,QDir::DirsFirst)) {
        QVariantMap entry;
        entry["fileName"] = fi.fileName ();
        entry["isDir"] = fi.isDir ();
        entry["isFile"] = fi.isFile ();
        entry["isSymLink"] = fi.isSymLink ();
        entry["size"] = fi.size ();
        entry["created"] = fi.created ().toString ("d.M.yyyy h:m:s");
        entry["lastModified"] = fi.lastModified ().toString ("d.M.yyyy h:m:s");
        entry["path"] = fi.filePath ();
        int o = (fi.permission (QFileDevice::ReadOwner) ? 0400 : 0)
                | (fi.permission (QFileDevice::WriteOwner) ?  0200 : 0)
                | (fi.permission (QFileDevice::ExeOwner) ? 0100 : 0)
                | (fi.permission (QFileDevice::ReadGroup) ? 040 : 0)
                | (fi.permission (QFileDevice::WriteGroup) ? 020 : 0)
                | (fi.permission (QFileDevice::ExeGroup) ? 010 : 0)
                | (fi.permission (QFileDevice::ReadOther) ? 04 : 0)
                | (fi.permission (QFileDevice::WriteOther) ? 02 : 0)
                | (fi.permission (QFileDevice::ExeOther) ? 01 : 0);
        entry["permission"] = o;
        result << entry;
    }

    return result;
}

QStringList BGFile::standardLocations(BGFile::StandardPaths type)
{
    return QStandardPaths::standardLocations ((QStandardPaths::StandardLocation)type);
}

QString BGFile::urlToPath(const QUrl& url) const
{
    QString path;
    if (url.isLocalFile ())
        path = url.toString (QUrl::PreferLocalFile);
    else {
        path = url.toString ();
        path.replace (QRegExp("^qrc://"), ":");
    }
    if (QFileInfo (path).isRelative ()) {
        //QString cp = CurrentPath;
        return CurrentPath + (CurrentPath.endsWith ('/') ? path : '/' + path);
    } else
        return path;
}

BGFileHandle* BGFile::open (const QUrl& file) const
{
    BGFileHandle* fh = new BGFileHandle (urlToPath (file));
    if (fh->open ())
        return fh;
    else {
        fh->deleteLater ();
        return NULL;
    }
}

void BGFile::close(BGFileHandle* fh) const
{
    fh->close ();
    fh->deleteLater ();
}

QObject* BGFile_singletontype_provider(QQmlEngine*, QJSEngine*)
{
    return new BGFile;
}
