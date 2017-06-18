/*****************************************************************************
 *   BGQuickLauncher - Quick/Qml script runtime environment
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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <bgqlcommon.h>
#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QtWebView/QtWebView>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QtWebView::initialize();

    qputenv("QML_DISABLE_DISK_CACHE", "true");

    QQmlApplicationEngine engine;
    initialEnvironment (&engine);

    app.setOrganizationName("BGStudio");
    app.setOrganizationDomain("org.BGStudio");
    app.setApplicationName("BGQuickLauncher");

    QSettings setting;
    QString shell = shellPath + setting.value ("shell", "Default").toString () + "/main.qml";

    if (!QFile::exists (shell)) {
        Q_INIT_RESOURCE (qml);
        //qDebug () << pluginsPath + "/libBGStudio.so";
        QDir pluginsDir;
#ifdef Q_OS_ANDROID
        qDebug () << "android";
        pluginsDir.setPath (":/Initial/plugins/android");
#else
        qDebug () << "desktop";
        pluginsDir.setPath (":/Initial/plugins/desktop");
#endif
        //QDir pluginsDir (":/Initial/plugins/");
        foreach (QFileInfo soFile, pluginsDir.entryInfoList ())
            qDebug () << QFile::copy (soFile.filePath (), pluginsPath + "/" + soFile.fileName ());
        engine.addImportPath (":/Initial/BGQuickLauncher/modules");
        //engine.addPluginPath (":/Initial/plugins");
        shell = "qrc:/setup.qml";
        //shell = shellPath + "Default/main.qml";
        //setting.setValue ("shell", "Default");
    }

    engine.load (QUrl(shell));

    return app.exec();
}
