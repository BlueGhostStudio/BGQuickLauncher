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

#ifndef LAUNCHERDATA_H
#define LAUNCHERDATA_H
#include <QtCore>
//#include <QQmlEngine>
#include <QQuickItem>
#include <QStandardPaths>
#include <QSettings>

/*#ifdef __QUICKVIEW__
#include <QQuickView>
typedef QQuickView ViewType;
#elif __QUICKWIDGET__
#include <QQuickWidget>
typedef QQuickWidget ViewType;
#endif*/
class Launcher;

struct App
{
    QString AppName;
    QString Title;
    QString IconSrc;
    QString Description;
    QString Qml;
    QString Category;
    App (const QVariantMap& app);
    App ();
    operator QVariantMap () const;
};

class Instance: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QVariantMap appInfo READ appInfo WRITE setAppInfo NOTIFY appInfoChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QQuickItem* instanceItem READ instanceItem WRITE setInstanceItem NOTIFY instanceItemChanged)
    Q_PROPERTY(Launcher* launcher READ launcher WRITE setLauncher NOTIFY launcherChanged)

public:
    Instance (QObject* parent = 0);
    int id () const;
    void setId (int _id);
    QVariantMap appInfo () const;
    void setAppInfo (const QVariantMap& info);
    QString title () const;
    void setTitle (const QString& t);
    QQuickItem* instanceItem () const;
    void setInstanceItem (QQuickItem* item);
    void setLauncher (Launcher* launcher);
    Launcher* launcher () const;
    Q_INVOKABLE QVariant settingValue (const QString& key, bool launcher = false) const;
    Q_INVOKABLE void setSettingValue (const QString& key, const QVariant& value, bool launcher = false) const;
    //void setAppInfo (const App& info);

signals:
    void idChanged ();
    void appInfoChanged ();
    void closed (Instance* instance);
    void instanceItemChanged ();
    void launcherChanged ();
    void titleChanged ();

public slots:
    void close ();

protected:
    int ID;
    App AppInfo;
    QString Title;
    QQuickItem* InstanceItem;
    Launcher* OwnLauncher;
};

/*class Instance: public QObject
{
    Q_OBJECT

public:
    static InstanceType* qmlAttachedProperties(QObject *object)
    {
        return new InstanceType(object);
    }
};

QML_DECLARE_TYPEINFO(Instance, QML_HAS_ATTACHED_PROPERTIES)*/

class Launcher: public QQuickItem
{
    Q_OBJECT
    /*Q_PROPERTY(const QString rootPath READ rootPath)
    Q_PROPERTY(const QString appsPath READ appsPath)
    Q_PROPERTY(const QString dataPath READ dataPath)
    Q_PROPERTY(const QString modulesPath READ modulesPath)*/
    Q_PROPERTY(const QVariantList appList READ appList NOTIFY appListChanged)
    Q_PROPERTY(const QVariantList instanceList READ instanceList NOTIFY instanceListChanged)


public:
    explicit Launcher(QQuickItem *parent = 0);
    /*static QString rootPath ();
    static QString appsPath ();
    static QString dataPath ();
    static QString modulesPath ();
    static QString shellPath ();*/
    QVariantList appList () const;
    QVariantList instanceList () const;

    Q_INVOKABLE QQuickItem* instanceItem (const int IID) const;
    Q_INVOKABLE Instance* instance (const int IID) const;
    Q_INVOKABLE void clearComponentCache ();

    static Instance* qmlAttachedProperties(QObject *object)
    {
        return new Instance(object);
    }

signals:
    void appListChanged ();
    void instanceListChanged ();
    void beforeNewInstance (const QString& appName);
    void newInstanceCreated (QQuickItem* item, Instance* instance);

public slots:
    void reloadAppList ();
    QQuickItem* newInstance (const QString& appName, bool autoPlace = true);

private:
    App getApp (const QString& appName) const;

protected:
    //static const QString RootPath;
    QList < App > AppList;
    QList < Instance* > Instances;
    int IID;
    QSettings LauncherSettings;
};

QML_DECLARE_TYPEINFO(Launcher, QML_HAS_ATTACHED_PROPERTIES)
Q_DECLARE_METATYPE(App)
#endif // LAUNCHERDATA_H
