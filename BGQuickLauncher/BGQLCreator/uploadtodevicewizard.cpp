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

#include "uploadtodevicewizard.h"
#include <bgqlcommon.h>
#include <QToolButton>
#include <QFileDialog>
#include <QLineEdit>
#include <QTreeWidgetItem>
#include <QMessageBox>
#include <QWizard>
#include <QProcess>

UploadToDeviceWizard::UploadToDeviceWizard(QWidget *parent) :
    QWizard(parent)
{
    setupUi(this);

    LVApps->setRootPath (appsPath);
    LVModules->setRootPath (modulesPath);
    LVShell->setRootPath (shellPath);

    setModal (true);

    initialConnect ();
}

void UploadToDeviceWizard::initialConnect()
{
    QObject::connect (TBAdd, &QToolButton::clicked, [=] () {
        QString path;
        switch (TWSourct->currentIndex ()) {
        case 0:
            path = LVApps->selPath ();
            if (!path.isEmpty () && !AppsSelect.contains (path))
                AppsSelect << path;
            break;
        case 1:
            path = LVModules->selPath ();
            if (!path.isEmpty () && !ModulesSelect.contains (path))
                ModulesSelect << path;
            break;
        case 2:
            path = LVShell->selPath ();
            if (!path.isEmpty () && !ShellSelect.contains (path))
                ShellSelect << path;
            break;
        case 3:
            path = LEPluginPath->text ();
            if (!path.isEmpty () && !PluginsSelect.contains (path))
                PluginsSelect << path;
        }
        refreshTargetList ();
    });

    QObject::connect (TBRemove, &QToolButton::clicked, [=] () {
        QTreeWidgetItem* item = TWTarget->currentItem ();
        if (item) {
            qDebug () << item->data (0, Qt::UserRole).toInt () << item->data (0, Qt::UserRole + 1).toString ();
            switch (item->data (0, Qt::UserRole).toInt ()) {
            case 0:
                AppsSelect.removeOne (item->data (0, Qt::UserRole + 1).toString ());
                break;
            case 1:
                ModulesSelect.removeOne (item->data (0, Qt::UserRole + 1).toString ());
                break;
            case 2:
                ShellSelect.removeOne (item->data (0, Qt::UserRole + 1).toString ());
                break;
            case 3:
                PluginsSelect.removeOne (item->data (0, Qt::UserRole + 1).toString ());
                break;
            default:
                break;
            }
        }
        refreshTargetList ();
    });

    QObject::connect (TBSelectPlugin, &QToolButton::clicked, [=] () {
        LEPluginPath->setText (
                    QFileDialog::getOpenFileName(
                        this, tr("Plugins"),
                        QStandardPaths::standardLocations (QStandardPaths::HomeLocation).first (),
                        tr("so (*.so)")));
    });

    QObject::connect (TBSelectDevice, &QToolButton::clicked, [=] () {
        LEDevicePath->setText (
                    QFileDialog::getExistingDirectory (this, tr("Device"))
                    );
    });

    QObject::connect (this, &QWizard::currentIdChanged, [=](int i) {
        if (i == 2) {
            QString devicePath = LEDevicePath->text ();
            if (devicePath.isEmpty ()) {
                QMessageBox::warning (this, "Device", "No device specified directory");
                return;
            }

            QProcess::execute ("mkdir " + devicePath + "/apps");
            foreach (QString path, AppsSelect) {
                QProcess::execute ("cp -rf " + path + " " + devicePath + "/apps");
            }
            QProcess::execute ("mkdir " + devicePath + "/modules");
            foreach (QString path, ModulesSelect) {
                QProcess::execute ("cp -rf " + path + " " + devicePath + "/modules");
            }
            QProcess::execute ("mkdir " + devicePath + "/Shell");
            foreach (QString path, ShellSelect) {
                QProcess::execute ("cp -rf " + path + " " + devicePath + "/Shell");
            }
            QProcess::execute ("mkdir " + devicePath + "/plugins");
            foreach (QString path, PluginsSelect) {
                QProcess::execute ("cp -rf " + path + " " + devicePath + "/plugins");
            }
        }
    });
}

void UploadToDeviceWizard::refreshTargetList()
{
    TWTarget->clear ();
    QTreeWidgetItem* appsTopItem = new QTreeWidgetItem (TWTarget, QStringList () << "Apps");
    foreach (QString path, AppsSelect) {
        QTreeWidgetItem* item = new QTreeWidgetItem (appsTopItem, QStringList () << QFileInfo (path).fileName () << path);
        item->setData (0, Qt::UserRole, 0);
        item->setData (0, Qt::UserRole + 1, path);
    }

    QTreeWidgetItem* modulesTopItem = new QTreeWidgetItem (TWTarget, QStringList () << "Modules");
    foreach (QString path, ModulesSelect){
        QTreeWidgetItem* item = new QTreeWidgetItem (modulesTopItem, QStringList () << QFileInfo (path).fileName () << path);
        item->setData (0, Qt::UserRole, 1);
        item->setData (0, Qt::UserRole + 1, path);
    }

    QTreeWidgetItem* shellTopItem = new QTreeWidgetItem (TWTarget, QStringList () << "Shell");
    foreach (QString path, ShellSelect){
        QTreeWidgetItem* item = new QTreeWidgetItem (shellTopItem, QStringList () << QFileInfo (path).fileName () << path);
        item->setData (0, Qt::UserRole, 2);
        item->setData (0, Qt::UserRole + 1, path);
    }

    QTreeWidgetItem* pluginsTopItem = new QTreeWidgetItem (TWTarget, QStringList () << "Plugins");
    foreach (QString path, PluginsSelect){
        QTreeWidgetItem* item = new QTreeWidgetItem (pluginsTopItem, QStringList () << QFileInfo (path).fileName () << path);
        item->setData (0, Qt::UserRole, 3);
        item->setData (0, Qt::UserRole + 1, path);
    }

    TWTarget->expandAll ();
}
