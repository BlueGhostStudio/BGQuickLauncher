/*****************************************************************************
 *   Common library of BGQuickLauncher and BGQLCreator
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

#include "launcher.h"
#include <QQmlComponent>
#include <QQmlEngine>
#include <bgqlcommon.h>

App::App(const QVariantMap &app)
{
    AppName = app["appName"].toString ();
    IconSrc = app["iconSrc"].toString ();
    Description = app["description"].toString ();
    Qml = app["qml"].toString ();
    Title = app["title"].toString ();
    Category = app["category"].toString ();
}

App::App()
{

}

App::operator QVariantMap () const
{
    QVariantMap var;
    var["appName"] = AppName;
    var["iconSrc"] = IconSrc;
    var["description"] = Description;
    var["qml"] = Qml;
    var["title"] = Title;
    var["category"] = Category;

    return var;
}

// ===================

Instance::Instance(QObject *parent)
    : QObject (parent), ID (0)
{
}

int Instance::id() const
{
    return ID;
}

void Instance::setId(int _id)
{
    ID = _id;
    idChanged ();
}

QVariantMap Instance::appInfo() const
{
    return AppInfo;
}

void Instance::setAppInfo(const QVariantMap &info)
{
    AppInfo = App(info);
    appInfoChanged ();
}

QString Instance::title() const
{
    return Title;
}

void Instance::setTitle(const QString& t)
{
    Title = t;
    titleChanged ();
}

QQuickItem* Instance::instanceItem() const
{
    return InstanceItem;
}

void Instance::setInstanceItem(QQuickItem* item)
{
    InstanceItem = item;
    QObject::connect (InstanceItem, &QQuickItem::destroyed, [=]() {
        closed (this);
    });
}

void Instance::setLauncher(Launcher* launcher)
{
    OwnLauncher = launcher;
}

Launcher* Instance::launcher() const
{
    return OwnLauncher;
}

QVariant Instance::settingValue(const QString& key, bool launcher) const
{
    if (launcher) {
        QSettings setting (settingPath, QSettings::IniFormat);;
        return setting.value (key);
    } else {
        QSettings setting (appsPath + AppInfo.AppName + "/appProp", QSettings::IniFormat);
        return setting.value (key);
    }
}

void Instance::setSettingValue(const QString& key, const QVariant& value, bool launcher) const
{
    if (launcher) {
        QSettings setting (settingPath, QSettings::IniFormat);
        setting.setValue (key, value);
    } else {
        QSettings setting (appsPath + AppInfo.AppName + "/appProp", QSettings::IniFormat);
        setting.setValue (key, value);
    }
}


void Instance::close()
{
    InstanceItem->deleteLater ();
}

// ===================

/*const QString Launcher::RootPath = QStandardPaths::standardLocations (
                         QStandardPaths::DocumentsLocation).first ()
                     + "/BGQuickLauncher/";
*/
Launcher::Launcher(QQuickItem* parent)
    :  QQuickItem(parent),
      IID (0)
{
    reloadAppList ();
}

/*QString Launcher::rootPath()
{
    return RootPath;
}

QString Launcher::appsPath()
{
    return RootPath + "apps/";
}

QString Launcher::dataPath()
{
    return RootPath + "data/";
}

QString Launcher::modulesPath()
{
    return RootPath + "modules/";
}

QString Launcher::shellPath()
{
    return RootPath + "Shell/Default/main.qml";
}*/

QVariantList Launcher::appList() const
{
    QVariantList apps;
    QList < App >::const_iterator it;
    for (it = AppList.begin (); it != AppList.end (); it++) {
        apps.append (QVariantMap (*it));
    }

    return apps;
}

QVariantList Launcher::instanceList() const
{
    QVariantList theInstList;
    QList < Instance* >::const_iterator it;
    for (it = Instances.begin (); it != Instances.end (); ++it) {
        QVariantMap inst;
        inst["id"] = (*it)->id ();
        inst["title"] = (*it)->title ();
        inst["appInfo"] = (*it)->appInfo ();
        theInstList.append (inst);
    }

    return theInstList;
}

QQuickItem* Launcher::instanceItem (const int IID) const
{
    Instance* theInstance = instance (IID);

    return theInstance ? theInstance->instanceItem () : NULL;
}

Instance* Launcher::instance(const int IID) const
{
    QList < Instance* >::const_iterator it;
    for (it = Instances.begin (); it != Instances.end (); it++){
        if ((*it)->id () == IID)
            break;
    }
    return it != Instances.end () ? *it : NULL;
}

void Launcher::clearComponentCache()
{
    qmlEngine (this)->clearComponentCache ();
}

void Launcher::reloadAppList()
{
    AppList.clear ();
    QDir appsDir (appsPath);
    QStringList appsDirEntries = appsDir.entryList (QDir::NoDotAndDotDot | QDir::Dirs);
    QStringList::iterator it;
    for (it = appsDirEntries.begin (); it != appsDirEntries.end (); it++) {
        App aApp;
        QSettings appProp (appsPath + *it + "/appProp", QSettings::IniFormat);
        appProp.setIniCodec ("UTF-8");
        aApp.AppName = *it;
        aApp.Title = appProp.value ("title", *it).toString ();
        aApp.IconSrc = appProp.value ("iconSrc", "icon.png").toString ();
        aApp.Description = appProp.value ("description", "").toString ();
        aApp.Qml = appsPath + *it + "/main.qml";
        aApp.Category = appProp.value ("category", "Default").toString ();
        AppList.append (aApp);
    }
}

QQuickItem* Launcher::newInstance(const QString& appName, bool autoPlace)
{
    App app = getApp (appName);
    beforeNewInstance (appName);
    QQmlEngine* engine = qmlEngine (this);

    if (LauncherSettings.value ("clearCompCache", false).toBool ())
        engine->clearComponentCache ();

    QQmlComponent instCmp (engine, QUrl::fromLocalFile (app.Qml));
    if (instCmp.isError ()) {
        foreach (QQmlError err, instCmp.errors ()) {
            qDebug () << "[error]" << err.toString ();
        }
        return NULL;
    }

    QQuickItem* item = qobject_cast < QQuickItem* > (instCmp.create ());

    Instance* instance = qobject_cast < Instance* > (
                        qmlAttachedPropertiesObject < Launcher > (item));
    instance->setId (IID);
    instance->setAppInfo (app);
    instance->setInstanceItem (item);
    instance->setLauncher (this);
    Instances.append (instance);
    IID++;

    if (autoPlace)
        item->setParentItem (this);

    item->update ();

    QObject::connect (instance, &Instance::closed, [=](Instance* instance){
        QList < Instance* >::iterator it;
        for (it = Instances.begin (); it != Instances.end (); it++){
            if ((*it)->id () == instance->id ())
                break;
        }
        if (it != Instances.end ()){
            Instances.erase (it);
            instanceListChanged ();
        }
    });

    instanceListChanged ();
    newInstanceCreated (item, instance);
    return item;
}

App Launcher::getApp(const QString &appName) const
{
    QList < App >::const_iterator it;
    for (it = AppList.begin (); it != AppList.end(); it++) {
        if (it->AppName == appName)
            return *it;
    }

    return App ();
}

