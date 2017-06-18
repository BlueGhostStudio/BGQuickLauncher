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

#include <QDebug>
#include <QMessageBox>
#include <bgqlcommon.h>
#include <QSettings>
#include <QInputDialog>
#include <bgqlcommon.h>
#include "project.h"
#include "addprjfiledlg.h"
#include "newprojectdialog.h"
#include "prjpropdlg.h"
#include "uploadtodevicewizard.h"
#include "QWizard"
#include "mainwindow.h"

Project::Project(QObject* parent)
    : QObject (parent)
{
}

void Project::setRelWidget(FileListView* flv, SourceEditorArea* ea, QQuickView* view)
{
    FLVFiles = flv;
    SEAEditors = ea;
    LauncherView = view;
}

void Project::setRelActions(QAction* _new, QAction* open, QAction* close, QAction* props,
                            QAction* newSrc, QAction* rmSrc, QAction* rnSrc, QAction* run, QAction* upload)
{
    ActNew = _new;
    ActOpen = open;
    ActClose = close;
    ActProperties = props;
    ActNewSource = newSrc;
    ActRemoveSource = rmSrc;
    ActRenameSource = rnSrc;
    ActRun = run;
    ActUpload = upload;

    ActNewSource->setEnabled (false);
    ActRemoveSource->setEnabled (false);
    ActClose->setEnabled (false);
    ActProperties->setEnabled (false);
    ActRenameSource->setEnabled (false);
    ActRun->setEnabled (false);

    initialConnect ();
}

void Project::newSource(const QString& fileName, const QString& templFile, const QString& path)
{
    QString thePath = PrjRootPath + "/" + path;
    QString newFile = thePath + "/" + fileName;
    QDir theDir (thePath);
    if (!theDir.exists () && !theDir.mkpath (thePath))
        QMessageBox::warning (0, "New Source", "Can't Make path- " + thePath);
    else if (!QFile::copy (templFile, newFile))
        QMessageBox::warning (0, "New Source", "Can't Create file-" + fileName);
    else
        QFile::setPermissions (newFile, QFileDevice::ReadOwner
                               | QFileDevice::WriteOwner
                               | QFileDevice::ReadGroup
                               | QFileDevice::ReadOther);
}

void Project::setProjectProperty(const QString& title, const QString& desc,
                                 const QString& iconSrc, const QString& category)
{
    QSettings appSet (PrjRootPath + "/appProp", QSettings::IniFormat);
    appSet.setValue ("title", title);
    appSet.setValue ("description", desc);
    appSet.setValue ("iconSrc", iconSrc);
    appSet.setValue ("category", category);
}

bool Project::isOpened() const
{
    return !PrjRootPath.isEmpty ();
}

void Project::openProject(const QString& prjPath)
{
    PrjRootPath = prjPath;
    FLVFiles->setRootPath (PrjRootPath);
    stateChanged ();
}

/*void Project::openProject ()
{
    if (closeProject ())
        OpenPrjDlg.open ();
}*/

bool Project::closeProject()
{
    bool ok = SEAEditors->closeAllEditor ();
    if (ok) {
        PrjRootPath.clear ();
        FLVFiles->setRootPath ("");
        stateChanged ();
    }

    return ok;
}

void Project::initialConnect()
{
    /*
     * 项目新建,打开及关闭
     */
    QObject::connect (ActNew, &QAction::triggered, [=] () {
        if (closeProject ()) {
            NewProjectDialog* theNewPrjDlg = new NewProjectDialog;
            theNewPrjDlg->open ();
            QObject::connect (theNewPrjDlg, &NewProjectDialog::finished, theNewPrjDlg, &NewProjectDialog::deleteLater);
            QObject::connect (theNewPrjDlg, &NewProjectDialog::accepted, [=] (){
                int prjType = theNewPrjDlg->prjType ();
                QString prjName = theNewPrjDlg->prjName ();
                QString prjPath;
                QPair < QString, QString > prjTemplate;
                switch (prjType) {
                case 0:
                    prjPath = appsPath + prjName;
                    prjTemplate.first = "main.qml";
                    prjTemplate.second = ":/template/qml.qml";
                    break;
                case 1:
                    prjPath = modulesPath + prjName;
                    prjTemplate.first = "qmldir";
                    prjTemplate.second = ":/template/qmldir";
                    break;
                case 2:
                    prjPath = shellPath + prjName;
                    prjTemplate.first = "main.qml";
                    prjTemplate.second = ":/template/shell.qml";
                    break;
                }
                if (QDir().mkpath (prjPath)) {
                    openProject (prjPath);
                    newSource (prjTemplate.first, prjTemplate.second, "/");
                    QString iconSrc = theNewPrjDlg->iconSrc ();
                    QString iconFileName;
                    if (!iconSrc.isEmpty ()) {
                        iconFileName = QFileInfo (iconSrc).fileName ();
                        QFile::copy (iconSrc, PrjRootPath + "/" + iconFileName);
                    }
                    setProjectProperty (theNewPrjDlg->title (), theNewPrjDlg->description (),
                                        iconFileName, theNewPrjDlg->category ());
                } else
                    QMessageBox::warning (0, "New Project", "Can create project Path");
            });
        }
    });
    /*QObject::connect (ActOpen, &QAction::triggered,
                      this, &Project::openProject);*/
    QObject::connect (ActOpen, &QAction::triggered, [=]() {
        if (closeProject ())
            OpenPrjDlg.open ();
    });
    QObject::connect (&OpenPrjDlg, &OpenProjectDialog::accepted, [=] () {
        openProject (OpenPrjDlg.prjPath ());
        /*PrjRootPath = OpenPrjDlg.prjPath ();
        FLVFiles->setRootPath (PrjRootPath);
        stateChanged ();*/
    });
    QObject::connect (ActClose, &QAction::triggered,
                      this, &Project::closeProject);

    /* 设置项目属性 */
    QObject::connect (ActProperties, &QAction::triggered, [=] () {
        PrjPropDlg* thePrjPropDlg = new PrjPropDlg (PrjRootPath);
        thePrjPropDlg->open ();
        QObject::connect (thePrjPropDlg, &PrjPropDlg::finished, thePrjPropDlg, &PrjPropDlg::deleteLater);
        QObject::connect (thePrjPropDlg, &PrjPropDlg::accepted, [=]() {
            QString iconSrc = thePrjPropDlg->iconSrc ();
            setProjectProperty (thePrjPropDlg->title (), thePrjPropDlg->description (),
                                QDir (PrjRootPath).relativeFilePath (iconSrc),
                                thePrjPropDlg->category ());
        });
    });
    /*
     * 项目文件相关
     */
    //增加项目文件
    QObject::connect (ActNewSource, &QAction::triggered, [=]() {
        AddPrjFileDlg* theAddDlg = new AddPrjFileDlg (QDir (PrjRootPath).relativeFilePath (FLVFiles->selDir ()));
        theAddDlg->open ();
        QObject::connect (theAddDlg, &AddPrjFileDlg::finished, [=] () {
            theAddDlg->deleteLater ();
        });
        QObject::connect (theAddDlg, &AddPrjFileDlg::accepted, [=] () {
            QString srcFile = theAddDlg->fileName ();
            QString tempFile;
            switch (theAddDlg->fileType ()) {
            case 0:
                srcFile += ".qml";
                tempFile = ":/template/qml.qml";
                break;
            case 1:
                srcFile += ".js";
                tempFile = ":/template/js.js";
                break;
            case 2:
                srcFile = "qmldir";
                tempFile = ":/template/qmldir";
                break;
            }
            newSource (srcFile, tempFile, theAddDlg->path ());
        });
    });
    //删除项目文件
    QObject::connect (ActRemoveSource, &QAction::triggered,[=]() {
        QString sourceFile = FLVFiles->selPath ();
        if (QMessageBox::question (0, "Remove Source", "Are you sure Remove it? - " + sourceFile,
                                   QMessageBox::Yes, QMessageBox::No) == QMessageBox::Yes
                && SEAEditors->closeEditor (sourceFile)) {
            FLVFiles->removeSelect ();
            /*if (isDir)
                QDir().rmpath (sourceFile);
            else
                QFile::remove (sourceFile);*/
        }
    });
    //打开项目文件
    QObject::connect (FLVFiles, &FileListView::clicked, [=](QModelIndex index) {
        SEAEditors->openSource (FLVFiles->filePath (index));
        //openFile (FLVFiles->filePath (index));
    });
    //修改文件名字
    QObject::connect (ActRenameSource, &QAction::triggered, [=]() {
        QString filePath = FLVFiles->selPath ();
        QDir dir(filePath.section ("/", 0, -2));
        QString oldName = filePath.section ("/", -1);
        bool ok;
        QString newName = QInputDialog::getText (0, "Rename", "New Name", QLineEdit::Normal, oldName, &ok);
        if (ok && SEAEditors->closeEditor (filePath)) {
            dir.rename (oldName, newName);
        }
    });

    //开关相关action状态
    QObject::connect (this, &Project::stateChanged, [=]() {
        ActNewSource->setEnabled (isOpened ());
        ActRemoveSource->setEnabled (isOpened ());
        ActProperties->setEnabled (isOpened ());
        ActClose->setEnabled (isOpened ());
        ActRenameSource->setEnabled (isOpened ());
        ActRun->setEnabled (isOpened ());
        LauncherView->close ();
    });

    // 运行项目应用
    QObject::connect (ActRun, &QAction::triggered, [=] (){
        LauncherView->engine ()->clearComponentCache ();
        LauncherView->setSource (QUrl(PrjRootPath + "/main.qml"));
        LauncherView->show ();
    });

    QObject::connect (ActUpload, &QAction::triggered, [=] () {
        UploadToDeviceWizard* wizard = new UploadToDeviceWizard (qobject_cast < MainWindow* > (parent ()));
        wizard->open ();
        QObject::connect (wizard, &UploadToDeviceWizard::finished, wizard, &UploadToDeviceWizard::deleteLater);
    });
}
