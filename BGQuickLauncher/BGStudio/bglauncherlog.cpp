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

#include "bglauncherlog.h"

BGLauncherLog* LauncherLogObj = NULL;

BGLauncherLog::BGLauncherLog(QObject *parent) : QObject(parent)
{

}

QString BGLauncherLog::log() const
{
    return Log;
}

void BGLauncherLog::appendLog(const QString& l, QtMsgType t)
{
    Log.append (l);
    logChanged ();
    qDebug () << t;
    switch (t) {
    case QtDebugMsg:
        LogDebug.append (l);
        logDebugChanged ();
        break;
    case QtInfoMsg:
        LogInfo.append (l);
        logInfoChanged ();
        break;
    case QtWarningMsg:
        LogWarning.append (l);
        logWarningChanged ();
        break;
    case QtCriticalMsg:
        LogCritical.append (l);
        logCriticalChanged ();
        break;
    case QtFatalMsg:
        LogFatal.append (l);
        logFatalChanged ();
        break;
    }
}

QString BGLauncherLog::logDebug() const
{
    return LogDebug;
}

QString BGLauncherLog::logWarning() const
{
    return LogWarning;
}

QString BGLauncherLog::logInfo() const
{
    return LogInfo;
}

QString BGLauncherLog::logCritical() const
{
    return LogCritical;
}

QString BGLauncherLog::logFatal() const
{
    return LogFatal;
}

void BGLauncherLog::clear()
{
    Log.clear ();
    LogDebug.clear ();
    LogWarning.clear ();
    LogInfo.clear ();
    LogCritical.clear ();
    LogFatal.clear ();

    logChanged ();
    logDebugChanged ();
    logWarningChanged ();
    logInfoChanged ();
    logCriticalChanged ();
    logFatalChanged ();
}

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    if (!LauncherLogObj)
        return;
    QByteArray localMsg = msg.toLocal8Bit();
    QString log;
    switch (type) {
    case QtDebugMsg:
        log = QString ("[DEBUG] %1\n").arg (localMsg.constData ());
        break;
    case QtInfoMsg:
        log = QString ("[INFO] %1\n").arg (localMsg.constData ());
        break;
    case QtWarningMsg:
        log = QString ("[Warning] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);
        break;
    case QtCriticalMsg:
        log = QString ("[Critical] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);
        break;
    case QtFatalMsg:
        log = QString ("[Fatal] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);
        break;
        //abort();
    }
    LauncherLogObj->appendLog (log, type);
}

QObject* BGLauncherLog_singletontype_provider(QQmlEngine*, QJSEngine*)
{
    LauncherLogObj = new BGLauncherLog;
    qInstallMessageHandler (myMessageOutput);
    return LauncherLogObj;
}
