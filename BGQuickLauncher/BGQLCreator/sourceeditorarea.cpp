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

#include <QMdiSubWindow>
#include <QAction>
#include <QDebug>
#include "sourceeditorarea.h"
#include <Qsci/qsciscintilla.h>
#include <Qsci/qscilexerjavascript.h>
#include <QMessageBox>
#include <QFileInfo>
#include <QMenu>
#include "sourceeditor.h"

SourceEditorArea::SourceEditorArea(QWidget *parent)
    : QMdiArea(parent)
{
    setViewMode (QMdiArea::TabbedView);
    setTabsMovable (true);
    setTabsClosable (true);
}

void SourceEditorArea::setRelWidget(QMenu* winMenu)
{
    WinMenu = winMenu;
    QObject::connect (WinMenu, &QMenu::aboutToShow, [=] () {
        WinMenu->clear ();
        WinMenu->addAction ("Tile", [=] () {
            tileSubWindows ();
        });
        WinMenu->addAction ("Cascade", [=] () {
            cascadeSubWindows ();
        });
        WinMenu->addAction ("Close", [=] () {
            closeActiveSubWindow ();
        });
        WinMenu->addAction ("Close All", [=] () {
            closeAllSubWindows ();
        });
        WinMenu->addSeparator ();
        foreach (QMdiSubWindow* se, subWindowList ()) {
            WinMenu->addAction (se->windowTitle (), [=] () {
                setActiveSubWindow (se);
            });
        }
    });
}

void SourceEditorArea::setRelActions(QAction* saveAll)
{
    QObject::connect (saveAll, &QAction::triggered, this, &SourceEditorArea::saveAllSource);
}

void SourceEditorArea::openSource(const QString& filePath)
{
    foreach (QMdiSubWindow* ew, subWindowList ()) {
        SourceEditor* editor = qobject_cast < SourceEditor* > (ew->widget ());
        if (editor && editor->filePath () == filePath) {
            setActiveSubWindow (ew);
            return;
        }
    }

    SourceEditor* editor = new SourceEditor ();
    if (editor->openSource (filePath)) {
        QMdiSubWindow* subWin = addSubWindow (editor);
        subWin->setBaseSize (600, 600);
        /*QObject::connect (subWin, &QMdiSubWindow::windowStateChanged, [=] (Qt::WindowStates os, Qt::WindowStates ns) {
            if ((os == Qt::WindowActive) && (ns == Qt::WindowNoState)) {
                SourceEditor* ae = activedEditor (subWin);
                if (ae) ae->disconnect ();
            }
        });*/
        newEditorCreated (editor);
        subWin->show ();
    } else
        editor->deleteLater ();
}

bool SourceEditorArea::saveAllSource()
{
    bool ok = true;
    foreach (QMdiSubWindow* ew, subWindowList ()) {
        SourceEditor* editor = qobject_cast < SourceEditor* > (ew->widget ());
        if (editor && editor->isModified ()) {
            if (!editor->saveSource ())
                ok = false;
        }
    }

    return ok;
}

bool SourceEditorArea::closeAllEditor()
{
    QList < QMdiSubWindow* > ews = subWindowList ();
    foreach (QMdiSubWindow* ew, ews) {
        SourceEditor* editor = qobject_cast < SourceEditor* > (ew->widget ());
        if (editor && editor->closeSource ())
            ew->close ();
        else
            return false;
    }

    return true;
}

bool SourceEditorArea::closeEditor(const QString& filePath)
{
    foreach (QMdiSubWindow* ew, subWindowList ()) {
        SourceEditor* editor = qobject_cast < SourceEditor* > (ew->widget ());
        if (editor && editor->filePath () == filePath) {
            if (editor->closeSource ())
                ew->close ();
            else
                return false;
            break;
        }
    }
    return true;
}
