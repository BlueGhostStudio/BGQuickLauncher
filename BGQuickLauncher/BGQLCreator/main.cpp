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

#include "mainwindow.h"
#include <QApplication>
#include <QQuickView>
#include <bgqlcommon.h>
#include <QDebug>

MainWindow* mainWindow;

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    if (!mainWindow)
        return;
    QByteArray localMsg = msg.toLocal8Bit();
    QString log;
    switch (type) {
    case QtDebugMsg:
        log = QString ("[DEBUG] %1").arg (localMsg.constData ());
        break;
    case QtInfoMsg:
        log = QString ("[INFO] %1").arg (localMsg.constData ());
        break;
    case QtWarningMsg:
        log = QString ("[Warning] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);;
        break;
    case QtCriticalMsg:
        log = QString ("[Critical] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);;
        break;
    case QtFatalMsg:
        log = QString ("[Fatal] %1 (%2:%3,%4)\n").arg (localMsg.constData ())
              .arg (context.file)
              .arg (context.line)
              .arg (context.function);;
        //abort();
    }
    mainWindow->log (log);
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setWindowIcon (QIcon (":/imgs/ghost.png"));
    a.setOrganizationName ("BGStudio");
    a.setApplicationName ("BGQLCreator");
    a.setOrganizationDomain ("org.BGStudio.com");

//    QQuickView view;
//    initialEnvironment (view.engine ());
//    view.setSource (QUrl(shellPath + "Default/mainCreator.qml"));
//    view.setResizeMode (QQuickView::SizeRootObjectToView);
//    view.setGeometry (0, 0, 640, 480);
//    view.setFlags (Qt::WindowMinMaxButtonsHint);
//    view.show ();


    mainWindow = new MainWindow;
    mainWindow->show();
    qInstallMessageHandler(myMessageOutput);

    return a.exec();
}
