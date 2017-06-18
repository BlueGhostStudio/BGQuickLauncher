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

#include "bgtextedit.h"
#include <QDebug>
#include <QQuickTextDocument>
#include <QTextCursor>
#include <QTextBlock>

BGTextEdit::BGTextEdit(QQuickItem* parent):
    QQuickItem(parent),
    TheBGSyntaxHighlighter (new BGSyntaxHighlighter (this)),
    ShiftPress (false)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);

    TheBGSyntaxHighlighter->loadHighlighterFormat (":/syntaxHighlighter/highlighter.json");
    TheBGSyntaxHighlighter->loadSyntax (":/syntaxHighlighter/syntax_qmljs.json");
}

BGTextEdit::~BGTextEdit()
{
}

QQuickItem* BGTextEdit::editControl() const
{
    return EditControl;
}

void BGTextEdit::setEditControl(QQuickItem* item)
{
    EditControl = item;
    TextDocument = EditControl->property ("textDocument").value < QQuickTextDocument* >()->textDocument ();
    EditControl->installEventFilter (this);

    TheBGSyntaxHighlighter->setDocument (TextDocument);

    QObject::connect (TextDocument, &QTextDocument::contentsChanged,
                      this, &BGTextEdit::lineNumberChanged);
    QObject::connect (TextDocument, &QTextDocument::modificationChanged, this,
                      &BGTextEdit::modifiedChanged);
    setModified (false);
}

void BGTextEdit::indent()
{
    QTextCursor textCursor = getTextCursor ();
    indent (textCursor);
}

void BGTextEdit::unindent()
{
    QTextCursor textCursor = getTextCursor ();
    unindent (textCursor);
}

QVariantList BGTextEdit::lineNumber() const
{
    QVariantList result;
    QTextBlock block = TextDocument->begin ();
    while (block != TextDocument->end ()) {
        result << block.position ();
        block = block.next ();
    }

    return result;
}

void BGTextEdit::setHighlighter(const QJsonObject& hl)
{
    TheBGSyntaxHighlighter->setHighlighterFormat (hl);
}

QJsonObject BGTextEdit::highlighter() const
{
    return TheBGSyntaxHighlighter->highlighterFormat ();
}

QString BGTextEdit::syntax() const
{
    return Syntax;
}

void BGTextEdit::setSyntax(const QString& syn)
{
    if (syn == "qmljs")
        TheBGSyntaxHighlighter->loadSyntax (":/syntaxHighlighter/syntax_qmljs.json");
}

QString BGTextEdit::syntaxFile() const
{
    return SyntaxFile;
}

void BGTextEdit::setSyntaxFile(const QString& file)
{
    SyntaxFile = file;
    TheBGSyntaxHighlighter->loadSyntax (file);
}

QColor BGTextEdit::hlBGColor() const
{
    return TheBGSyntaxHighlighter->bgColor ();
}

void BGTextEdit::setHlBGColor(const QColor& color)
{
    TheBGSyntaxHighlighter->setBGColor (color);
}

qreal BGTextEdit::hlContrastFactor() const
{
    return TheBGSyntaxHighlighter->contrastFactor ();
}

void BGTextEdit::setHlContrastFactor(qreal factor)
{
    TheBGSyntaxHighlighter->setContrastFactor (factor);
}

bool BGTextEdit::modified() const
{
    return TextDocument ? TextDocument->isModified () : false;
}

void BGTextEdit::setModified(bool m)
{
    if (TextDocument) {
        TextDocument->setModified (m);
        modifiedChanged ();
    }
}

bool BGTextEdit::eventFilter(QObject* watched, QEvent* event)
{
    auto enter = [this] () {
        QRegExp EX("^\\s*");
        QTextCursor textCursor = getTextCursor ();
        EX.indexIn (textCursor.block ().text ());
        textCursor.insertText ('\n' + QString ().fill (' ', EX.matchedLength ()));
    };

    if (watched == EditControl) {
        if (event->type () == QEvent::KeyPress) {
            bool accept = false;
            QKeyEvent* keyEvent = static_cast < QKeyEvent* > (event);
            QTextCursor textCursor = getTextCursor ();
            if (keyEvent->key () == Qt::Key_Shift)
                ShiftPress = true;
            else if (keyEvent->key () == Qt::Key_Tab) {
                if (ShiftPress) {
                    unindent (textCursor);
                    accept = true;
                } else if (textCursor.hasSelection ())
                    indent (textCursor);
                else
                    textCursor.insertText ("    ");
                accept = true;
            } else if (keyEvent->key () == Qt::Key_Backtab) {
                unindent (textCursor);
                accept = true;
            } else if (keyEvent->key () == Qt::Key_Return
                       || keyEvent->key () == Qt::Key_Enter) {
                /*QRegExp EX("^\\s*");
                EX.indexIn (textCursor.block ().text ());
                textCursor.insertText ('\n' + QString ().fill (' ', EX.matchedLength ()));*/
                enter ();
                accept = true;
            }

            if (keyEvent->key () != Qt::Key_Shift)
                ShiftPress = false;

            return accept;
        } else if (event->type () == QEvent::InputMethod) {
            QInputMethodEvent* inputEvent = static_cast < QInputMethodEvent* > (event);
            if (inputEvent->commitString () == "\n") {
                enter ();
                return true;
            }

            //qDebug () << inputEvent->commitString ();
        }
        return false;
    } else
        return false;
}

QTextCursor BGTextEdit::getTextCursor()
{
    int selStart = EditControl->property ("selectionStart").toInt ();
    int selEnd = EditControl->property ("selectionEnd").toInt ();
    QTextCursor textCursor (TextDocument);
    textCursor.setPosition (selStart);
    textCursor.setPosition (selEnd, QTextCursor::KeepAnchor);

    return textCursor;
}

void BGTextEdit::indent(QTextCursor& textCursor)
{
    int end = textCursor.selectionEnd ();
    QTextBlock block = TextDocument->findBlock (textCursor.selectionStart ());
    do {
        textCursor.setPosition (block.position ());
        textCursor.insertText ("    ");
        block = block.next ();
        end += 4;
        //qDebug () << end << textCursor.selectionEnd ();
    } while (block.isValid () && block.position () <= end);
}

void BGTextEdit::unindent(QTextCursor& textCursor)
{
    int end = textCursor.selectionEnd ();
    QTextBlock block = TextDocument->findBlock (textCursor.selectionStart ());
    do {
        textCursor.setPosition (block.position ());
        QRegExp EX("^\\s{0,4}");
        EX.indexIn (block.text ());
        for (int i = 0; i < EX.matchedLength (); i++)
            textCursor.deleteChar ();

        block = block.next ();
        end -= EX.matchedLength ();
    } while (block.isValid () && block.position () <= end);
}
