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

#ifndef BGLAUNCHERLOG_H
#define BGLAUNCHERLOG_H

#include <QQuickItem>
#include <QObject>

class BGLauncherLog : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString log READ log NOTIFY logChanged)
    Q_PROPERTY(QString logDebug READ logDebug NOTIFY logDebugChanged)
    Q_PROPERTY(QString logWarning READ logWarning NOTIFY logWarningChanged)
    Q_PROPERTY(QString logInfo READ logInfo NOTIFY logInfoChanged)
    Q_PROPERTY(QString logCritical READ logCritical NOTIFY logCriticalChanged)
    Q_PROPERTY(QString logFatal READ logFatal NOTIFY logFatalChanged)
public:
    explicit BGLauncherLog(QObject *parent = 0);

    QString log () const;
    void appendLog (const QString& l, QtMsgType t);
    QString logDebug () const;
    QString logWarning () const;
    QString logInfo () const;
    QString logCritical () const;
    QString logFatal () const;
    Q_INVOKABLE void clear ();

signals:
    void logChanged ();
    void logDebugChanged ();
    void logWarningChanged ();
    void logInfoChanged ();
    void logCriticalChanged ();
    void logFatalChanged ();

public slots:

private:
    QString LogDebug;
    QString LogWarning;
    QString LogInfo;
    QString LogCritical;
    QString LogFatal;

    QString Log;
};

QObject* BGLauncherLog_singletontype_provider(QQmlEngine*, QJSEngine*);

#endif // BGLAUNCHERLOG_H
