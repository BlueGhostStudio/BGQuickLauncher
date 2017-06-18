/*****************************************************************************
 *   BGStudio - Quick/Qml model, mis fun writer by BGStudio
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

#ifndef BGEVENT_H
#define BGEVENT_H

#include <QQuickItem>
#include <QObject>
#include <QKeyEvent>

class BGEvent : public QObject
{
    Q_OBJECT
public:
    explicit BGEvent(QObject *parent = 0);

    enum EventType {
        KeyPress = QEvent::KeyPress,
        KeyRelease = QEvent::KeyRelease
    };
    Q_ENUM(EventType)
    enum KeyboardModifier {
        NoModified = Qt::NoModifier,
        ShiftModifier = Qt::ShiftModifier,
        ControlModifier = Qt::ControlModifier,
        AltModifier = Qt::AltModifier,
        MetaModifier = Qt::MetaModifier,
        KeypadModifier = Qt::KeypadModifier,
        GroupSwitchModifier = Qt::GroupSwitchModifier
    };
    Q_ENUM(KeyboardModifier)

    Q_INVOKABLE void postEventKey (QObject* receiver, int type, int key, int modifiers = 0,
                                   const QString& text = QString (), bool autorep = false,
                                   ushort count = 1);

signals:

public slots:
};

QObject* BGEvent_singletontype_provider(QQmlEngine* /*engine*/, QJSEngine* /*scriptEngine*/);

#endif // BGEVENT_H
