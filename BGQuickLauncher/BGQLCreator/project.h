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

#ifndef PROJECT_H
#define PROJECT_H

#include <QObject>
#include <QAction>
#include <QQuickView>
#include "openprojectdialog.h"
#include "filelistview.h"
#include "sourceeditorarea.h"

class Project : public QObject
{
    Q_OBJECT

public:
    Project(QObject* parent = 0);

    void setRelWidget (FileListView* flv, SourceEditorArea* ea, QQuickView* view);
    void setRelActions (QAction* _new, QAction* open, QAction* close, QAction* props,
                        QAction* newSrc, QAction* rmSrc, QAction* rnSrc, QAction* run, QAction* upload);
    void newSource (const QString& fileName, const QString& templFile, const QString& path);
    void setProjectProperty (const QString& title, const QString& desc,
                             const QString& iconSrc, const QString& category);
    bool isOpened () const;

public slots:
    void openProject (const QString& prjPath);
    bool closeProject();

signals:
    //void openFile (const QString& path);
    //void closed ();
    void stateChanged ();

private:
    void initialConnect ();
    OpenProjectDialog OpenPrjDlg;
    QString PrjRootPath;
    FileListView* FLVFiles;
    SourceEditorArea* SEAEditors;

    QAction* ActNew;
    QAction* ActOpen;
    QAction* ActClose;
    QAction* ActProperties;
    QAction* ActNewSource;
    QAction* ActRemoveSource;
    QAction* ActRenameSource;
    QAction* ActRun;
    QAction* ActUpload;

    QQuickView* LauncherView;
};

#endif // PROJECT_H
