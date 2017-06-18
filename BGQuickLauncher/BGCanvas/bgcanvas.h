/*****************************************************************************
 *   BGCanvas - Quick/Qml module, draw graphics
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

#ifndef BGCANVAS_H
#define BGCANVAS_H

#include <QQuickPaintedItem>
#include <QQuickItem>
#include <QPainterPath>
#include <QObject>
#include <QBrush>
#include <QPen>
#include <QQmlListProperty>

class BGPathBase : public QObject {
    Q_OBJECT

    Q_PROPERTY(qreal x READ x WRITE setX
               NOTIFY xChanged)
    Q_PROPERTY(qreal y READ y WRITE setY
               NOTIFY yChanged)
    Q_PROPERTY(QColor fillColor READ fillColor
               WRITE setFillColor NOTIFY fillColorChanged)
    Q_PROPERTY(int fillStyle READ fillStyle
               WRITE setFillStyle NOTIFY fillStyleChanged)
    Q_PROPERTY(QColor strokeColor READ strokeColor
               WRITE setStrokeColor NOTIFY strokeColorChanged)
    Q_PROPERTY(QVariantMap gradient READ gradient WRITE setGradient NOTIFY gradientChanged)
    Q_PROPERTY(bool blur READ blur WRITE setBlur NOTIFY blurChanged)
    Q_PROPERTY(int blurRadius READ blurRadius WRITE setBlurRadius NOTIFY blurRadiusChanged)
    Q_PROPERTY(bool shadow READ shadow WRITE setShadow NOTIFY shadowChanged)
    Q_PROPERTY(qreal shdXOffset READ shdXOffset WRITE setShdXOffset NOTIFY shdXOffsetChanged)
    Q_PROPERTY(qreal shdYOffset READ shdYOffset WRITE setShdYOffset NOTIFY shdYOffsetChanged)
    Q_PROPERTY(QColor shdColor READ shdColor WRITE setShdColor NOTIFY shdColorChanged)

public:
    BGPathBase (QObject* parent = 0);

    QColor fillColor () const;
    void setFillColor (const QColor& color);
    QColor strokeColor () const;
    void setStrokeColor (const QColor& color);
    qreal x () const;
    void setX (qreal _x);
    qreal y () const;
    void setY (qreal _y);
    int fillStyle () const;
    void setFillStyle (int style);
    QVariantMap gradient () const;
    void setGradient (const QVariantMap& _g);
    bool blur () const;
    void setBlur (bool b);
    int blurRadius () const;
    void setBlurRadius (int r);
    bool shadow () const;
    void setShadow (bool shd);
    bool shdXOffset () const;
    void setShdXOffset (qreal xo);
    bool shdYOffset () const;
    void setShdYOffset (qreal xo);
    QColor shdColor () const;
    void setShdColor (const QColor& shdc);

    void drawPath (QPainter* painter, const QPainterPath& _path);
    virtual void draw (QPainter*) {}

signals:
    void xChanged ();
    void yChanged ();
    void fillColorChanged ();
    void strokeColorChanged ();
    void fillStyleChanged ();
    void gradientChanged ();
    void blurChanged ();
    void blurRadiusChanged ();
    void shadowChanged ();
    void shdXOffsetChanged ();
    void shdYOffsetChanged ();
    void shdColorChanged ();

private:
    QImage pathToImg (QPainter* painter, const QPainterPath& path, int margins) const;
    QImage blur (const QImage& image, int radius, const QColor& replaceColor) const;

protected:
    QBrush FillBrush;
    QPen StrokePen;
    Qt::BrushStyle FillStyle;
    qreal X;
    qreal Y;
    QVariantMap Gradient;
    bool Blur;
    int BlurRadius;
    bool Shadow;
    qreal SHDXOffset;
    qreal SHDYOffset;
    QColor SHDColor;
};

class BGRect : public BGPathBase
{
    Q_OBJECT

    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged)

public:
    BGRect (QObject* parent = 0);

    qreal width () const;
    void setWidth (qreal _w);
    qreal height () const;
    void setHeight (qreal _h);
    void draw (QPainter* painter);

signals:
    void widthChanged ();
    void heightChanged ();

protected:
    qreal Width;
    qreal Height;
};

class BGRoundedRect : public BGRect
{
    Q_OBJECT

    Q_PROPERTY(qreal xRadius READ xRadius WRITE setXRadius NOTIFY xRadiusChanged)
    Q_PROPERTY(qreal yRadius READ yRadius WRITE setYRadius NOTIFY yRadiusChanged)

public:
    BGRoundedRect (QObject* parent = 0);
    void draw (QPainter *painter);

    qreal xRadius () const;
    void setXRadius (qreal r);
    qreal yRadius () const;
    void setYRadius (qreal r);

signals:
    void xRadiusChanged ();
    void yRadiusChanged ();

protected:
    qreal XRadius;
    qreal YRadius;
};

class BGPathElemBase : public QObject {
    Q_OBJECT

public:
    BGPathElemBase (QObject* parent = 0);

    virtual void addToPath (QPainterPath& /*path*/) {}
};

class BGLineTo : public BGPathElemBase {
    Q_OBJECT
    Q_PROPERTY(qreal x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(qreal y READ y WRITE setY NOTIFY yChanged)

public:
    BGLineTo (QObject* parent = 0);
    void addToPath (QPainterPath& path);

    qreal x () const;
    void setX (qreal _x);
    qreal y () const;
    void setY (qreal _y);

signals:
    void xChanged ();
    void yChanged ();

protected:
    qreal X;
    qreal Y;
};

class BGArcTo : public BGLineTo {
    Q_OBJECT
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(qreal startAngle READ startAngle WRITE setStartAngle NOTIFY startAngleChanged)
    Q_PROPERTY(qreal arcLength READ arcLength WRITE setArcLength NOTIFY arcLengthChanged)

public:
    BGArcTo (QObject* parent = 0);
    qreal width () const;
    void setWidth (qreal _w);
    qreal height () const;
    void setHeight (qreal _h);
    qreal startAngle () const;
    void setStartAngle (qreal a);
    qreal arcLength () const;
    void setArcLength (qreal len);

    void addToPath (QPainterPath& path);

signals:
    void widthChanged ();
    void heightChanged ();
    void startAngleChanged ();
    void arcLengthChanged ();

protected:
    qreal Width;
    qreal Height;
    qreal StartAngle;
    qreal ArcLength;
};

class BGQuadTo : public BGLineTo {
    Q_OBJECT
    Q_PROPERTY(qreal cx READ cx WRITE setCx NOTIFY cxChanged)
    Q_PROPERTY(qreal cy READ cy WRITE setCy NOTIFY cyChanged)

public:
    BGQuadTo (QObject* parent = 0);

    qreal cx () const;
    void setCx (qreal _x);
    qreal cy () const;
    void setCy (qreal _y);

    void addToPath (QPainterPath& path);

signals:
    void cxChanged ();
    void cyChanged ();

protected:
    qreal CX;
    qreal CY;
    qreal EndX;
    qreal EndY;
};

class BGCubicTo : public BGQuadTo {
    Q_OBJECT
    Q_PROPERTY(qreal cx2 READ cx2 WRITE setCx2 NOTIFY cx2Changed)
    Q_PROPERTY(qreal cy2 READ cy2 WRITE setCy2 NOTIFY cy2Changed)

public:
    BGCubicTo (QObject* parent = 0);

    qreal cx2 () const;
    void setCx2 (qreal _x);
    qreal cy2 () const;
    void setCy2 (qreal _y);

    void addToPath (QPainterPath& path);

signals:
    void cx2Changed ();
    void cy2Changed ();

protected:
    qreal CX2;
    qreal CY2;
};

class BGPath : public BGPathBase {
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<BGPathElemBase> elems READ elems)
    Q_PROPERTY(bool closePath READ closePath WRITE setClosePath NOTIFY closePathChanged)
    Q_PROPERTY(bool windingFill READ windingFill WRITE setWindingFill NOTIFY windingFillChanged)

public:
    BGPath (QObject* parent = 0);

    QQmlListProperty<BGPathElemBase> elems ();

    void draw (QPainter* painter);

    bool closePath () const;
    void setClosePath (bool c);
    bool windingFill () const;
    void setWindingFill (bool wf);

private:
    static void appendElem (QQmlListProperty<BGPathElemBase>* list, BGPathElemBase* pe);
    static int elemCount (QQmlListProperty<BGPathElemBase>* list);
    static BGPathElemBase* elem (QQmlListProperty<BGPathElemBase>* list, int i);
    static void clearElems (QQmlListProperty<BGPathElemBase>* list);

signals:
    void closePathChanged ();
    void windingFillChanged ();

protected:
    QList < BGPathElemBase* > Elems;
    bool ClosePath;
    bool WindingFill;
};

class BGEllipse : public BGRect
{
    Q_OBJECT

public:
    BGEllipse (QObject* parent = 0);
    void draw (QPainter* painter);
};

class BGCanvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<BGPathBase> paths READ paths)

public:
    BGCanvas(QQuickItem *parent = nullptr);
    ~BGCanvas();

    QQmlListProperty<BGPathBase> paths ();

    void paint (QPainter* painter);
    Q_INVOKABLE void requestPaint ();

private:
      static void appendPath(QQmlListProperty<BGPathBase>* list, BGPathBase* p);
      static int pathCount(QQmlListProperty<BGPathBase>* list);
      static BGPathBase* path(QQmlListProperty<BGPathBase>* list, int i);
      static void clearPaths(QQmlListProperty<BGPathBase>* list);

protected:
    QList < BGPathBase* > Paths;
};

#endif // BGCANVAS_H
