/*****************************************************************************
 *   BGControls - Quick/Qml module, Controls.
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

#ifndef BGLINEEDIT_H
#define BGLINEEDIT_H

#include <QQuickItem>
#include <QTextDocument>
#include "bgsyntaxhighlighter.h"
#include <QJsonObject>

class BGTextEdit : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(BGTextEdit)
    Q_PROPERTY(QQuickItem* editControl READ editControl WRITE setEditControl NOTIFY editControlChanged)
    Q_PROPERTY(QVariantList lineNumber READ lineNumber NOTIFY lineNumberChanged)
    Q_PROPERTY(QJsonObject highlighter READ highlighter WRITE setHighlighter NOTIFY highlighterChanged)
    Q_PROPERTY(QString syntax READ syntax WRITE setSyntax NOTIFY syntaxChanged)
    Q_PROPERTY(QString syntaxFile READ syntaxFile WRITE setSyntaxFile NOTIFY syntaxFileChanged)

    Q_PROPERTY(QColor hlBGColor READ hlBGColor WRITE setHlBGColor NOTIFY hlBGColorChanged)
    Q_PROPERTY(qreal hlContrastFactor READ hlContrastFactor WRITE setHlContrastFactor NOTIFY hlContrastFactorChanged)
    Q_PROPERTY(bool modified READ modified WRITE setModified NOTIFY modifiedChanged)

public:
    BGTextEdit(QQuickItem *parent = 0);
    ~BGTextEdit();

    QQuickItem* editControl () const;
    void setEditControl (QQuickItem* item);
    Q_INVOKABLE void indent ();
    Q_INVOKABLE void unindent ();
    Q_INVOKABLE QVariantList lineNumber () const;

    void setHighlighter (const QJsonObject& hl);
    QJsonObject highlighter () const;
    QString syntax () const;
    void setSyntax (const QString& syn);
    QString syntaxFile () const;
    void setSyntaxFile (const QString& file);

    QColor hlBGColor () const;
    void setHlBGColor (const QColor& color);
    qreal hlContrastFactor () const;
    void setHlContrastFactor (qreal factor);

    bool modified () const;
    void setModified (bool m);

signals:
    void editControlChanged ();
    void lineNumberChanged ();
    void highlighterChanged ();
    void syntaxChanged ();
    void syntaxFileChanged ();
    void hlBGColorChanged ();
    void hlContrastFactorChanged ();
    void modifiedChanged ();

protected:
    bool eventFilter (QObject *watched, QEvent *event);

private:
    QTextCursor getTextCursor ();
    void indent (QTextCursor& textCursor);
    void unindent (QTextCursor& textCursor);
    QQuickItem* EditControl;
    QTextDocument* TextDocument;
    BGSyntaxHighlighter* TheBGSyntaxHighlighter;

    QString Syntax;
    QString SyntaxFile;

    bool ShiftPress;
};

#endif // BGLINEEDIT_H
