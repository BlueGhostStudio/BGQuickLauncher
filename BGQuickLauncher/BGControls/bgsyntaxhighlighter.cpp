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

#include <QDebug>
#include "bgsyntaxhighlighter.h"
#include <QTextCharFormat>
#include <QFile>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QRegularExpression>

BGSyntaxHighlighter::BGSyntaxHighlighter(QObject* parent)
    : QSyntaxHighlighter (parent), MultiLineSyntax (10), ContrastFactor (0.5)
{
}

void BGSyntaxHighlighter::highlightBlock(const QString& text)
{
    QTextCharFormat format;
    //format.setForeground (HighlighterFormat["normal"].value < QBrush > ());
    format.setForeground (colorByCate ("normal"));
    setFormat (0, text.length (), format);

    int beginIndex = 0;

    int preBlockState = previousBlockState ();
    if (preBlockState > 0) {
        QString endP = MultiLineSyntax[preBlockState][0];
        QRegularExpression endExt (endP);
        QRegularExpressionMatch endMath = endExt.match (text);
        int endIndex = endMath.capturedStart ();

        //format.setForeground (HighlighterFormat[MultiLineSyntax[preBlockState][1]].value < QBrush > ());
        format.setForeground (colorByCate (MultiLineSyntax[preBlockState][1]));
        if (endIndex == -1) {
            setFormat (0, text.length (), format);
            setCurrentBlockState (preBlockState);
        } else {
            setFormat (0, endIndex + endMath.capturedLength (), format);
            beginIndex = endIndex + endMath.capturedLength ();
            setCurrentBlockState (0);
        }
    } else {
        QJsonArray cates = SyntaxJson.array ();
        for (int i = 0; i < cates.size (); i++)
            highlightContext (i, text, beginIndex);
            //highlightContext (it.key (), text, beginIndex);
    }
    /*qDebug () << "in highlightBlock";
    QRegExp rex ("\\b[A-Z]\\S*\\b(?=\\s*\\{)");
    int index = 0;
    index = rex.indexIn (text);
    qDebug () << index;
    while (index >= 0) {
        int len = rex.matchedLength ();
        QTextCharFormat format;
        format.setForeground (Qt::red);
        setFormat (index, len, format);
        index = rex.indexIn (text, index + len);
    }*/
}

bool BGSyntaxHighlighter::loadSyntax(const QString& file)
{
    QFile syntaxJsonFile (file);

    if (syntaxJsonFile.open (QIODevice::ReadOnly)) {
        QJsonParseError error;
        SyntaxJson = QJsonDocument::fromJson (syntaxJsonFile.readAll (), &error);
        if (error.error != QJsonParseError::NoError)
            return false;
        else
            return true;
    } else
        return false;
}

bool BGSyntaxHighlighter::loadHighlighterFormat(const QString& file)
{
    QFile highlighterFile (file);
    if (highlighterFile.open (QIODevice::ReadOnly)) {
        QJsonParseError error;
        QJsonObject hlJson = QJsonDocument::fromJson (highlighterFile.readAll (), &error).object ();
        if (error.error != QJsonParseError::NoError)
            return false;
        else {
            QJsonObject::iterator it;
            for (it = hlJson.begin (); it != hlJson.end (); ++it) {
                HighlighterFormat[it.key ()] = QColor (it.value ().toString ());
            }
            return true;
        }
    } else
        return false;
}

void BGSyntaxHighlighter::setHighlighterFormat(const QJsonObject& hlJson)
{
    QJsonObject::const_iterator it;
    for (it = hlJson.begin (); it != hlJson.end (); ++it) {
        HighlighterFormat[it.key ()] = QColor (it.value ().toString ());
    }
}

QJsonObject BGSyntaxHighlighter::highlighterFormat() const
{
    return QJsonObject::fromVariantMap (HighlighterFormat);
}

QColor BGSyntaxHighlighter::bgColor() const
{
    return Background;
}

void BGSyntaxHighlighter::setBGColor(const QColor& color)
{
    Background = color;
}

qreal BGSyntaxHighlighter::contrastFactor() const
{
    return ContrastFactor;
}

void BGSyntaxHighlighter::setContrastFactor(qreal factor)
{
    ContrastFactor = factor;
}

void BGSyntaxHighlighter::highlightContext(int cateIndex, const QString& text, const int beginIndex)
{
    QJsonObject cateObj = SyntaxJson.array ()[cateIndex].toObject ();
    QString cate = cateObj["cate"].toString ();
    QJsonArray syntaxArray = cateObj["syntax"].toArray ();
    foreach (QJsonValue v, syntaxArray) {
        QString p;
        QString begP;
        QString endP;
        int state;
        if (v.isString ())
            p = "\\b" + v.toString () + "\\b";
        else if (v.isObject ()) {
            QJsonObject obj = v.toObject ();
            if (obj.contains ("pattern"))
                p = obj["pattern"].toString ();
            else if (obj.contains ("start")) {
                begP = obj["start"].toString ();
                endP = obj["end"].toString ();
                state = obj["state"].toInt ();
                MultiLineSyntax[state]
                        = QVector < QString > () << endP
                          << cate;
            }
        }

        QTextCharFormat format;
        //format.setForeground (HighlighterFormat[cate].value < QBrush > ());
        format.setForeground (colorByCate (cate));
        colorByCate (cate);

        if (!p.isNull ()) {
            QRegularExpression rex (p);

            QRegularExpressionMatch match = rex.match (text, beginIndex);
            int index = match.capturedStart ();//rex.indexIn (text);
            /*if (index >= 0)
                setCurrentBlockState (0);*/
            while (index >= 0) {
                int len = match.capturedLength ();
                int delIndex = match.capturedStart ("del");
                /*if (delIndex >= 0)
                    setFormat (index, index + len - delIndex, format);
                else*/
                    setFormat (index, len, format);
                match = rex.match (text, index + len);
                index = match.capturedStart ();
            }
        } else if (!begP.isNull ()) {
            QRegularExpression rex (begP);
            QRegularExpressionMatch match = rex.match (text, beginIndex);
            int index = match.capturedStart ();
            while (index >= 0) {
                QRegularExpression endRex (endP);
                QRegularExpressionMatch endMatch = endRex.match (text, index + match.capturedLength ());
                int endIndex = endMatch.capturedStart ();
                if (endIndex == -1) {
                    setCurrentBlockState (state);
                    setFormat (index, text.length () - index, format);
                    break;
                } else {
                    setFormat (index, endIndex - index + endMatch.capturedLength (), format);
                    index = endIndex + endMatch.capturedLength ();
                }
            }
        }
    }
}

QColor BGSyntaxHighlighter::colorByCate(const QString& cate)
{
    QColor color = HighlighterFormat[cate].value < QColor > ();

    qreal v = Background.valueF ();
    if (v < 0.5)
        v += ContrastFactor;
    else
        v -= ContrastFactor;

    color.setHsvF (color.hsvHueF (), color.hsvSaturationF (), v);

    return color;
}
