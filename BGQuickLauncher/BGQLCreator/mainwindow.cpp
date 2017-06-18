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
#include <bgqlcommon.h>
#include <QMdiSubWindow>
#include <QDebug>
#include <QPainter>
#include <QClipboard>
#include <QTextBrowser>
#include <QDockWidget>
#include <QMainWindow>
#include "filelistview.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent), TheProject (this)
{
    setupUi(this);

    initialConnect ();
    initialActionIcon ();
    resetSourceActions ();
    //resetEditAction ();

    initialEnvironment (LauncherView.engine ());
    LauncherView.setResizeMode (QQuickView::SizeRootObjectToView);
    LauncherView.setGeometry (0, 0, 384, 640);

    TheProject.setRelWidget (FLVFiles, SEAEditors, &LauncherView);
    TheProject.setRelActions (actionNewProject, actionOpenProject, actionCloseProject,
                              actionProjectProperties,
                              actionAddProjectFile, actionRemoveProjectFile,
                              actionProjectFileRename,
                              actionRun, actionUpload_to_Device);
    SEAEditors->setRelActions (actionSaveAllSource);
    SEAEditors->setRelWidget (winMenu);

    QSettings settings("BGStudio", "BGQLCreator");
    restoreGeometry (settings.value ("Geometry").toByteArray ());
    LogDock->restoreGeometry (settings.value ("Log/Geometry").toByteArray ());
}

void MainWindow::log(const QString& l)
{
    TBLogs->append (l);
}

void MainWindow::resetSourceActions()
{
    actionSaveSource->setEnabled (false);
    actionSaveAllSource->setEnabled (false);

    actionCopy->setEnabled (false);
    actionCut->setEnabled (false);
    actionPaste->setEnabled (false);
    actionUndo->setEnabled (false);
    actionRedo->setEnabled (false);
}

void MainWindow::closeEvent(QCloseEvent* event)
{
    QSettings settings("BGStudio", "BGQLCreator");
    settings.setValue("Geometry", saveGeometry ());
    settings.setValue("Log/Geometry", LogDock->saveGeometry ());

    if (SEAEditors->closeAllEditor ()) {
        //LauncherView.deleteLater ();
        event->accept ();
    } else
        event->ignore ();
}

void MainWindow::initialConnect()
{
    /*QObject::connect (actionLuncher, &QAction::triggered, [=] () {
        LauncherView.show ();
    });*/

    QObject::connect (SEAEditors, &SourceEditorArea::subWindowActivated, [=](QMdiSubWindow* subWin) {
        if (!subWin)
            resetSourceActions ();
        else
            actionSaveAllSource->setEnabled (true);
    });
    QObject::connect (SEAEditors, &SourceEditorArea::newEditorCreated, [=](SourceEditor* editor) {
        editor->setRefActions (actionSaveSource,
                               actionCopy, actionCut, actionPaste,
                               actionUndo, actionRedo, actionRun);
    });

    QObject::connect (QGuiApplication::clipboard(), &QClipboard::dataChanged,
                      [=]() {
        actionPaste->setEnabled (!QGuiApplication::clipboard()->text ().isEmpty ()
                                 && SEAEditors->subWindowList () .count () > 0);
    });
    //QObject::connect (actionSaveAllSource, &QAction::triggered, SEAEditors, &SourceEditorArea::saveAllSource);
}

QIcon MainWindow::emblemIcon(const QIcon& icon1, const QIcon& icon2) const
{
    QSize iconSize (22, 22); //= icon1.actualSize (QSize (128, 128));
    QPixmap pix1 = icon1.pixmap (iconSize);
    QPixmap pix2 = icon2.pixmap (iconSize/2);

    QPainter emblemPainter (&pix1);
    emblemPainter.setCompositionMode (QPainter::CompositionMode_Clear);
    emblemPainter.eraseRect (iconSize.width () / 2, iconSize.height () /2,
                             iconSize.width () / 2, iconSize.height () /2);
    emblemPainter.setCompositionMode (QPainter::CompositionMode_SourceOver);
    emblemPainter.drawPixmap (iconSize.width () / 2, iconSize.height () /2,
                              iconSize.width () / 2, iconSize.height () /2,pix2);

    return QIcon (pix1);
}

void MainWindow::initialActionIcon()
{
    actionNewProject->setIcon (emblemIcon (QIcon::fromTheme ("document-new"), QIcon::fromTheme ("system-run-symbolic")));
    actionOpenProject->setIcon (emblemIcon (QIcon::fromTheme ("document-open"), QIcon::fromTheme ("system-run-symbolic")));
    actionCloseProject->setIcon (emblemIcon (QIcon::fromTheme ("document-close"), QIcon::fromTheme ("system-run-symbolic")));
    actionProjectProperties->setIcon (emblemIcon (QIcon::fromTheme ("settings-configure"), QIcon::fromTheme ("system-run-symbolic")));
    actionAddProjectFile->setIcon (emblemIcon (QIcon::fromTheme ("text-x-generic"), QIcon::fromTheme ("list-add")));
    actionRemoveProjectFile->setIcon (emblemIcon (QIcon::fromTheme ("text-x-generic"), QIcon::fromTheme ("delete")));
    actionProjectFileRename->setIcon (emblemIcon (QIcon::fromTheme ("text-x-generic"), QIcon::fromTheme ("edit-rename")));
}
