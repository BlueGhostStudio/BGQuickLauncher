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

#ifndef SOURCEEDITOR_H
#define SOURCEEDITOR_H

#include <Qsci/qsciscintilla.h>
#include <Qsci/qscilexerjavascript.h>
#include <QMdiArea>
#include <QMdiSubWindow>

class SourceEditor : public QsciScintilla
{
    Q_OBJECT
public:
    explicit SourceEditor(QWidget *parent = 0);
    void setRefActions (QAction* save,
                        QAction* copy, QAction* cut, QAction* paste,
                        QAction* undo, QAction* redo, QAction* run);
    bool openSource(const QString& filePath);
    bool closeSource ();
    QString filePath () const;

public slots:
    void resetAcions ();
    bool saveSource ();

signals:

protected:
    void closeEvent (QCloseEvent *event);

private:
    void initialConnect ();
    void resetEditActionConnect ();
    void disEditConnect ();
    QMdiSubWindow* parentSubWin ();
    bool isActive ();
    QString FilePath;

    QAction* ActSave;
    QAction* ActCopy;
    QAction* ActCut;
    QAction* ActPaste;
    QAction* ActUndo;
    QAction* ActRedo;
    QAction* ActRun;
};

#endif // SOURCEEDITOR_H
