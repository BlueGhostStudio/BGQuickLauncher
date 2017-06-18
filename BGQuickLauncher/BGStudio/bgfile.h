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

#ifndef BGFILE_H
#define BGFILE_H

#include <QQuickItem>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QFileSystemWatcher>

class BGFileHandle : public QObject
{
    Q_OBJECT
public:
    BGFileHandle (const QString& fileName, QObject *parent = 0);
    
    bool open ();
    void close ();
    Q_INVOKABLE bool seek (qint64 pos);
    Q_INVOKABLE qint64 pos () const;
    Q_INVOKABLE QByteArray readAll ();
    Q_INVOKABLE QByteArray read (qint64 maxLen);
    Q_INVOKABLE QVariantList readAllb();
    Q_INVOKABLE QVariantList readb (qint64 maxLen);
    Q_INVOKABLE qint64 write (const QByteArray& data);
    Q_INVOKABLE QFileDevice::FileError error () const;
    Q_INVOKABLE QString errorString () const;

private:
    QFile File;
};

class BGFile : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(BGFile)
    Q_PROPERTY(QUrl currentPath READ currentPath WRITE chdir NOTIFY currentPathChanged)

public:
    BGFile(QObject *parent = 0);
    ~BGFile();

    enum StandardPaths  {
        Desktop = QStandardPaths::DesktopLocation,
        Documents = QStandardPaths::DocumentsLocation,
        Fonts = QStandardPaths::FontsLocation,
        Applications = QStandardPaths::ApplicationsLocation,
        Music = QStandardPaths::MusicLocation,
        Movies = QStandardPaths::MoviesLocation,
        Pictures = QStandardPaths::PicturesLocation,
        Temp = QStandardPaths::TempLocation,
        Home = QStandardPaths::HomeLocation,
        Data = QStandardPaths::DataLocation,
        Cache = QStandardPaths::CacheLocation,
        GenericCache = QStandardPaths::GenericCacheLocation,
        GenericData = QStandardPaths::GenericDataLocation,
        Runtime = QStandardPaths::RuntimeLocation,
        Config = QStandardPaths::ConfigLocation,
        Download = QStandardPaths::DownloadLocation,
        GenericConfig = QStandardPaths::GenericConfigLocation,
        AppData = QStandardPaths::AppDataLocation,
        AppLocalData = QStandardPaths::AppLocalDataLocation,
        AppConfig = QStandardPaths::AppConfigLocation
    };
    Q_ENUM(StandardPaths)

    enum DirFilter {
        Dirs = QDir::Dirs,
        AllDirs = QDir::AllDirs,
        Files = QDir::Files,
        Drives = QDir::Drives,
        NoSymLinks = QDir::NoSymLinks,
        NoDotAndDotDot = QDir::NoDotAndDotDot,
        NoDot = QDir::NoDot,
        NoDotDot = QDir::NoDotDot,
        AllEntries = QDir::AllEntries,
        Readable = QDir::Readable,
        Writable = QDir::Writable,
        Executable = QDir::Executable,
        Modified = QDir::Modified,
        Hidden = QDir::Hidden,
        System = QDir::System,
        CaseSensitive = QDir::CaseSensitive
    };
    Q_ENUM(DirFilter)

    QUrl currentPath () const;
    Q_INVOKABLE void chdir (const QUrl& url);
    Q_INVOKABLE QByteArray readFile (const QUrl& fileUrl) const;
    Q_INVOKABLE bool writeFile (const QUrl& fileUrl, const QByteArray& data) const;
    Q_INVOKABLE bool mv (const QUrl& sUrl, const QUrl& tUrl) const;
    Q_INVOKABLE bool cp (const QUrl& sUrl, const QUrl& tUrl) const;
    Q_INVOKABLE bool rm (const QUrl& url) const;
    Q_INVOKABLE bool mkpath (const QUrl& url) const;
    Q_INVOKABLE bool rmpath (const QUrl& url) const;
    Q_INVOKABLE bool exists (const QUrl& url) const;
    Q_INVOKABLE QVariantList fileList (const QUrl& url, const QStringList& nameFilter = QStringList (),
                                       int filters = QDir::NoFilter) const;
    Q_INVOKABLE QStringList	standardLocations (StandardPaths type);
    Q_INVOKABLE QString urlToPath (const QUrl& url) const;

    Q_INVOKABLE BGFileHandle* open (const QUrl& file) const;
    Q_INVOKABLE void close (BGFileHandle* fh) const;
    
signals:
    void currentPathChanged ();

private:
    mutable QFileDevice::FileError LastError;
    mutable QString LastErrorString;
    QString CurrentPath;
};

QObject* BGFile_singletontype_provider(QQmlEngine* /*engine*/, QJSEngine* /*scriptEngine*/);

#endif // BGFILE_H
