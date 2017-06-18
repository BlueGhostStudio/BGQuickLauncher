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

#ifndef BGSYNTAXHIGHLIGHTER_H
#define BGSYNTAXHIGHLIGHTER_H
#include <QSyntaxHighlighter>
#include <QJsonDocument>

class BGSyntaxHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT

public:
     BGSyntaxHighlighter (QObject* parent = 0);
     void highlightBlock (const QString &text);
     bool loadSyntax (const QString& file);
     bool loadHighlighterFormat (const QString& file);
     void setHighlighterFormat (const QJsonObject& hlJson);
     QJsonObject highlighterFormat() const;

     QColor bgColor () const;
     void setBGColor (const QColor& color);
     qreal contrastFactor () const;
     void setContrastFactor (qreal factor);

private:
     void highlightContext (int cateIndex, const QString& text, const int beginIndex);
     QColor colorByCate(const QString& cate);

private:
     QJsonDocument SyntaxJson;
     QVariantMap HighlighterFormat;
     QVector < QVector < QString > > MultiLineSyntax;
     QColor Background;
     qreal ContrastFactor;
 };

 #endif // BGSYNTAXHIGHLIGHTER_H
