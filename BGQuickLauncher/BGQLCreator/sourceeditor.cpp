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

#include <QFileInfo>
#include <QDebug>
#include <QAction>
#include <QGuiApplication>
#include <QClipboard>
#include <QMessageBox>
#include <QCloseEvent>
#include "sourceeditor.h"

SourceEditor::SourceEditor(QWidget *parent) : QsciScintilla(parent)
{
    setMarginLineNumbers (0, true);
    setMarginWidth (0, 32);
    setLexer (new QsciLexerJavaScript);
    setFolding (QsciScintilla::BoxedTreeFoldStyle, 3);
    setAutoIndent (true);
    setIndentationsUseTabs (false);
    setIndentationWidth (4);
    setTabIndents (true);
    setUtf8 (true);
}

void SourceEditor::setRefActions(QAction* save,
                                 QAction* copy, QAction* cut, QAction* paste,
                                 QAction* undo, QAction* redo, QAction* run)
{
    ActSave = save;
    ActCopy = copy;
    ActCut = cut;
    ActPaste = paste;
    ActUndo = undo;
    ActRedo = redo;
    ActRun = run;

    initialConnect ();
}

bool SourceEditor::openSource(const QString& filePath)
{
    QFileInfo fileInfo (filePath);
    QRegExp ex ("(jpg|jpeg|png|gif|bmp)");
    if (fileInfo.isDir () || ex.exactMatch (fileInfo.suffix ()))
        return false;

    QFile file (filePath);
    FilePath = filePath;
    if (file.open (QIODevice::ReadOnly)) {
        setText (file.readAll ());
        setModified (false);
        file.close ();
        setWindowTitle (fileInfo.fileName ());
        return true;
    }
    return false;
}

bool SourceEditor::saveSource()
{
    //if (isActive ()) {
        QFile file (FilePath);
        if (file.open (QIODevice::WriteOnly)) {
            file.write (text ().toUtf8 ());
            setModified (false);
            file.close ();
            ActSave->setEnabled (false);
            //ActRun->trigger ();
            return true;
        }
    //}

    return false;
}

void SourceEditor::closeEvent(QCloseEvent* event)
{
    if (closeSource ())
        event->accept ();
    else
        event->ignore ();
}

bool SourceEditor::closeSource ()
{
    if (isModified ()) {
        int res = QMessageBox::question (this, "Close File",
                                         FilePath + "\nThis file has modified.save it?",
                                         QMessageBox::Yes, QMessageBox::No, QMessageBox::Cancel);
        if (res == QMessageBox::Cancel)
            return false;
        else if (res == QMessageBox::Yes)
            saveSource ();
    }

    return true;
}

QString SourceEditor::filePath() const
{
    return FilePath;
}

void SourceEditor::resetAcions()
{
    ActSave->setEnabled (isModified ());
    //actionSaveAllSource->setEnabled (true);
    QObject::connect (this, &QsciScintilla::modificationChanged,
                      ActSave, &QAction::setEnabled);

    ActCopy->setEnabled (hasSelectedText ());
    ActCut->setEnabled (ActCopy->isEnabled ());
    QObject::connect (this, &SourceEditor::copyAvailable, ActCopy, &QAction::setEnabled);
    QObject::connect (this, &SourceEditor::copyAvailable, ActCut, &QAction::setEnabled);
    ActPaste->setEnabled (!QGuiApplication::clipboard()->text ().isEmpty ());

    ActUndo->setEnabled (isUndoAvailable ());
    ActRedo->setEnabled (isRedoAvailable ());
    QObject::connect (this, &SourceEditor::textChanged, [=] {
        ActUndo->setEnabled (isUndoAvailable ());
        ActRedo->setEnabled (isRedoAvailable ());
    });

    // reset action connect to editor
    resetEditActionConnect ();
}

/*void SourceEditor::resetActionsBeforeDestroy()
{
    ActSave->setEnabled (false);
    //actionSaveAllSource->setEnabled (false);

    ActCopy->setEnabled (false);
    ActCut->setEnabled (false);
    ActPaste->setEnabled (false);
    ActUndo->setEnabled (false);
    ActUndo->setEnabled (false);
}*/

void SourceEditor::initialConnect()
{
    /*QObject::connect (parentSubWin (), &QMdiSubWindow::aboutToActivate,
                      this, &SourceEditor::resetAcions);*/
    QObject::connect (parentSubWin (), &QMdiSubWindow::windowStateChanged,
                      [=](Qt::WindowStates os, Qt::WindowStates ns) {
        if (os == Qt::WindowActive && ns == Qt::WindowNoState)
            disEditConnect ();
        else if (ns == Qt::WindowActive)
            resetAcions ();
    });
    QObject::connect (this, &SourceEditor::modificationChanged, [=](bool m) {
        setWindowTitle (QFileInfo(FilePath).fileName () + (m ? " *" : ""));
    });
}

void SourceEditor::resetEditActionConnect()
{
    QObject::connect (ActSave, &QAction::triggered, [=] () {
        if (saveSource ())
            ActSave->setEnabled (false);
    });
    QObject::connect (ActCopy, &QAction::triggered, this, &SourceEditor::copy);
    QObject::connect (ActCut, &QAction::triggered, this, &SourceEditor::cut);
    QObject::connect (ActPaste, &QAction::triggered, this, &SourceEditor::paste);

    QObject::connect (ActUndo, &QAction::triggered, this, &SourceEditor::undo);
    QObject::connect (ActRedo, &QAction::triggered, this, &SourceEditor::redo);
}

void SourceEditor::disEditConnect()
{
    ActSave->disconnect ();
    ActCopy->disconnect ();
    ActCut->disconnect ();
    ActPaste->disconnect ();
    ActUndo->disconnect ();
    ActRedo->disconnect ();
}

QMdiSubWindow* SourceEditor::parentSubWin()
{
    return qobject_cast < QMdiSubWindow* > (parent ());
}

bool SourceEditor::isActive()
{
    QMdiSubWindow* subWin = parentSubWin ();
    return subWin->mdiArea ()->currentSubWindow () == subWin;
}
