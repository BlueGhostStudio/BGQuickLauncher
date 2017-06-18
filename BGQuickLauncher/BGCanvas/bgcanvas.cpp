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

#include "bgcanvas.h"
#include <QPainter>
#include <QDebug>
#include <QtMath>

// class BGPathBase
BGPathBase::BGPathBase(QObject* parent)
    : QObject (parent), FillBrush(Qt::NoBrush),
      StrokePen(Qt::NoPen), FillStyle(Qt::NoBrush),
      Blur (false), Shadow(false), SHDXOffset (0), SHDYOffset (0),
      SHDColor (0,0,0,96)
{
}

QColor BGPathBase::fillColor() const
{
    return FillBrush.color ();
}

void BGPathBase::setFillColor(const QColor& color)
{
    if (FillStyle == Qt::NoBrush)
        FillStyle = Qt::SolidPattern;
    FillBrush.setStyle (FillStyle);
    FillBrush.setColor (color);
    fillColorChanged ();
}

QColor BGPathBase::strokeColor() const
{
    return StrokePen.color ();
}

void BGPathBase::setStrokeColor(const QColor& color)
{
    if (StrokePen.style () == Qt::NoPen)
        StrokePen.setStyle (Qt::SolidLine);
    StrokePen.setColor (color);
    strokeColorChanged ();
}

qreal BGPathBase::x() const
{
    return X;
}

void BGPathBase::setX(qreal _x)
{
    X = _x;
    xChanged ();
}

qreal BGPathBase::y() const
{
    return Y;
}

void BGPathBase::setY(qreal _y)
{
    Y = _y;
    yChanged ();
}

int BGPathBase::fillStyle () const
{
    return FillBrush.style ();
}

void BGPathBase::setFillStyle(int style)
{
    FillStyle = (Qt::BrushStyle)style;
    fillStyleChanged ();
}

QVariantMap BGPathBase::gradient() const
{
    return Gradient;
}

void BGPathBase::setGradient(const QVariantMap& _g)
{
    Gradient = _g;
    gradientChanged ();
}

bool BGPathBase::blur() const
{
    return Blur;
}

void BGPathBase::setBlur(bool b)
{
    Blur = b;
    blurChanged ();
}

int BGPathBase::blurRadius() const
{
    return BlurRadius;
}

void BGPathBase::setBlurRadius(int r)
{
    BlurRadius = r;
    blurRadiusChanged ();
}

bool BGPathBase::shadow() const
{
    return Shadow;
}

void BGPathBase::setShadow(bool shd)
{
    Shadow = shd;
    shadowChanged ();
}

bool BGPathBase::shdXOffset() const
{
    return SHDXOffset;
}

void BGPathBase::setShdXOffset(qreal xo)
{
    SHDXOffset = xo;
    shdXOffsetChanged ();
}

bool BGPathBase::shdYOffset() const
{
    return SHDXOffset;
}

void BGPathBase::setShdYOffset(qreal xo)
{
    SHDYOffset = xo;
    shdYOffsetChanged ();
}

QColor BGPathBase::shdColor() const
{
    return SHDColor;
}

void BGPathBase::setShdColor(const QColor& shdc)
{
    SHDColor = shdc;
    shdColorChanged ();
}

void BGPathBase::drawPath(QPainter* painter, const QPainterPath& _path)
{
    auto sg = [&,this](QGradient& g) {
        QVariantList stops = Gradient["stops"].toList ();
        foreach (QVariant st, stops) {
            QVariantMap stm = st.toMap ();
            g.setColorAt (stm["pos"].toReal (), QColor (stm["color"].toString ()));
        }
        painter->setBrush (g);
    };
    if (FillStyle == Qt::LinearGradientPattern) {
        QLinearGradient linearGradient (Gradient["start"].toPointF (), Gradient["end"].toPointF ());
        sg (linearGradient);
    } else if (FillStyle == Qt::RadialGradientPattern) {
        QRadialGradient radialGradient (Gradient["center"].toPointF (), Gradient["radius"].toReal ());
        sg (radialGradient);
    } else if (FillStyle == Qt::ConicalGradientPattern) {
        QConicalGradient conicalGradient (Gradient["center"].toPointF (), Gradient["angle"].toReal ());
        sg (conicalGradient);
    } else
        painter->setBrush (FillBrush);
    painter->setPen (StrokePen);

    if (Blur || Shadow) {
        QImage source = pathToImg (painter, _path, BlurRadius);
        QRectF srcRect = _path.boundingRect ();
        if (Blur) {
            source = blur (source, BlurRadius, QColor ());
            painter->drawImage (srcRect.x () - BlurRadius, srcRect.y () - BlurRadius, source);
        } else {
            source = blur (source, BlurRadius, SHDColor);
            painter->drawImage (srcRect.x () - BlurRadius + SHDXOffset,
                                srcRect.y () - BlurRadius + SHDYOffset,
                                source);
            painter->drawPath (_path);
        }
    } else
        painter->drawPath (_path);
}

QImage BGPathBase::pathToImg(QPainter* painter, const QPainterPath& path, int margins) const
{
    QRectF srcRect = path.boundingRect ();
    QPainterPath tmpPath (path);
    tmpPath.translate (margins - srcRect.x (), margins - srcRect.y ());
    QImage result ((int)(srcRect.width () + margins * 2),
                   (int)(srcRect.height () + margins * 2),
                   QImage::Format_ARGB32_Premultiplied);
    result.fill (0);

    QPainter p;
    p.begin (&result);
    p.setPen (painter->pen ());
    p.setBrush (painter->brush ());
    p.drawPath (tmpPath);
    p.end ();

    return result;
}

/*void BGPathBase::blur(QPainter* painter, const QPainterPath& path, int radius) const
{
    QRectF srcRect = path.boundingRect ();
    QPainterPath tmpPath (path);
    tmpPath.translate (radius - srcRect.x (), radius - srcRect.y ());
    QImage source ((int)(srcRect.width () + radius * 2),
                   (int)(srcRect.height () + radius * 2),
                   QImage::Format_ARGB32_Premultiplied);
    source.fill (0);

    qDebug () << painter->pen ().color () << painter->pen ().style ();
    QPainter p;
    p.setRenderHints(QPainter::Antialiasing, true);
    p.begin (&source);
    p.setPen (painter->pen ());
    p.setBrush (painter->brush ());
    p.drawPath (tmpPath);
    p.end ();
}*/

QImage BGPathBase::blur(const QImage& image, int radius, const QColor& replaceColor) const
{
    QImage result (image.width (), image.height (), QImage::Format_ARGB32_Premultiplied);
    for (int ih = 0; ih < image.height (); ih++) {
        int sumA = 0;
        int sumR = 0;
        int sumG = 0;
        int sumB = 0;

        for (int irh = ih - radius; irh <= ih + radius; irh++) {
            for (int irw = 0; irw <= radius; irw++) {
                if (irw < image.width ()
                        && irh >= 0 && irh < image.height ()) {
                    QColor c = image.pixelColor (irw, irh);
                    sumA += c.alpha ();
                    if (!replaceColor.isValid ()) {
                        sumR += c.red ();
                        sumG += c.green ();
                        sumB += c.blue ();
                    }
                }
            }
        }
        for (int iw = 0; iw < image.width (); iw ++) {

            int count = qPow (radius * 2 + 1, 2);
            if (replaceColor.isValid ()) {
                result.setPixelColor (iw, ih,
                                      QColor (replaceColor.red (),
                                              replaceColor.green (),
                                              replaceColor.blue (),
                                              sumA / count * replaceColor.alpha () / 255));
            } else
                result.setPixelColor (iw, ih, QColor (sumR / count,
                                                      sumG / count,
                                                      sumB / count,
                                                      sumA / count));

            int o = iw - radius;
            int n = iw + radius + 1;
            for (int i = -radius; i <= radius; i++) {
                if (ih + i >= 0 && ih + i < image.height ()) {
                    QColor oc = o >= 0 ? image.pixelColor (o, ih + i) : QColor (0,0,0,0);
                    QColor nc = n < image.width () ? image.pixelColor (n, ih + i) : QColor (0,0,0,0);
                    sumA += nc.alpha () - oc.alpha ();
                    if (!replaceColor.isValid ()) {
                        sumR += nc.red () - oc.red ();
                        sumG += nc.green () - oc.green ();
                        sumB += nc.blue () - oc.blue ();
                    }
                }
            }
        }
    }

    return result;
}

// class BGRect

BGRect::BGRect(QObject* parent)
    : BGPathBase (parent)
{

}

qreal BGRect::width() const
{
    return Width;
}

void BGRect::setWidth(qreal _w)
{
    Width = _w;
    widthChanged ();
}

qreal BGRect::height() const
{
    return Height;
}

void BGRect::setHeight(qreal _h)
{
    Height = _h;
    heightChanged ();
}

void BGRect::draw(QPainter* painter)
{
    //BGPathBase::draw (painter);
    QPainterPath pPath;
    pPath.addRect (X, Y, Width, Height);

    drawPath (painter, pPath);
}

// class BGRoundRect

BGRoundedRect::BGRoundedRect(QObject* parent)
    : BGRect (parent)
{

}

void BGRoundedRect::draw(QPainter* painter)
{
    QPainterPath pPath;
    pPath.addRoundedRect (X, Y, Width, Height, XRadius, YRadius);

    drawPath (painter, pPath);
}

qreal BGRoundedRect::xRadius() const
{
    return XRadius;
}

void BGRoundedRect::setXRadius(qreal r)
{
    XRadius = r;
    xRadiusChanged ();
}

qreal BGRoundedRect::yRadius() const
{
    return YRadius;
}

void BGRoundedRect::setYRadius(qreal r)
{
    YRadius = r;
    yRadiusChanged ();
}

// class BGEllipse

BGEllipse::BGEllipse(QObject* parent)
    : BGRect (parent)
{

}

void BGEllipse::draw(QPainter* painter)
{
    //BGPathBase::draw (painter);
    QPainterPath pPath;
    pPath.addEllipse (X, Y, Width, Height);

    drawPath (painter, pPath);
    //painter->drawPath (pPath);
}

// class BGPathElemBase

BGPathElemBase::BGPathElemBase(QObject* parent)
    : QObject (parent)
{

}

// class BGLineTo

BGLineTo::BGLineTo(QObject* parent)
    : BGPathElemBase (parent)
{

}

void BGLineTo::addToPath(QPainterPath& path)
{
    path.lineTo (X, Y);
}

qreal BGLineTo::x() const
{
    return X;
}

void BGLineTo::setX(qreal _x)
{
    X = _x;
    xChanged ();
}

qreal BGLineTo::y() const
{
    return Y;
}

void BGLineTo::setY(qreal _y)
{
    Y = _y;
    yChanged ();
}

// class BGArcTo

BGArcTo::BGArcTo(QObject* parent)
    : BGLineTo (parent)
{
}

qreal BGArcTo::width() const
{
    return Width;
}

void BGArcTo::setWidth(qreal _w)
{
    Width = _w;
    widthChanged ();
}

qreal BGArcTo::height() const
{
    return Height;
}

void BGArcTo::setHeight(qreal _h)
{
    Height = _h;
    heightChanged ();
}

qreal BGArcTo::startAngle() const
{
    return StartAngle;
}

void BGArcTo::setStartAngle(qreal a)
{
    StartAngle = a;
    startAngleChanged ();
}

qreal BGArcTo::arcLength() const
{
    return ArcLength;
}

void BGArcTo::setArcLength(qreal len)
{
    ArcLength = len;
    arcLengthChanged ();
}

void BGArcTo::addToPath(QPainterPath& path)
{
    path.arcTo (X, Y, Width, Height, StartAngle, ArcLength);
}

// class BGQuadTo

BGQuadTo::BGQuadTo(QObject* parent)
    : BGLineTo (parent)
{

}

qreal BGQuadTo::cx() const
{
    return CX;
}

void BGQuadTo::setCx(qreal _x)
{
    CX = _x;
    cxChanged ();
}

qreal BGQuadTo::cy() const
{
    return CY;
}

void BGQuadTo::setCy(qreal _y)
{
    CY = _y;
    cyChanged ();
}

void BGQuadTo::addToPath(QPainterPath& path)
{
    path.quadTo (CX, CY, X, Y);
}

// class BGCubicTo

BGCubicTo::BGCubicTo(QObject* parent)
    : BGQuadTo (parent)
{

}

qreal BGCubicTo::cx2() const
{
    return CX2;
}

void BGCubicTo::setCx2(qreal _x)
{
    CX2 = _x;
    cx2Changed ();
}

qreal BGCubicTo::cy2() const
{
    return CY2;
}

void BGCubicTo::setCy2(qreal _y)
{
    CY2 = _y;
    cy2Changed ();
}

void BGCubicTo::addToPath(QPainterPath& path)
{
    path.cubicTo (CX, CY, CX2, CY2, X, Y);
}

// class BGPath

BGPath::BGPath(QObject* parent)
    : BGPathBase (parent), ClosePath (false)
{

}

QQmlListProperty<BGPathElemBase> BGPath::elems()
{
    return QQmlListProperty < BGPathElemBase > (this, 0,
                                                &BGPath::appendElem,
                                                &BGPath::elemCount,
                                                &BGPath::elem,
                                                &BGPath::clearElems);
}

void BGPath::draw(QPainter* painter)
{
    QPainterPath pPath (QPointF(X, Y));
    foreach (BGPathElemBase* e, Elems) {
        e->addToPath (pPath);
    }

    if (ClosePath)
        pPath.closeSubpath ();

    if (WindingFill)
        pPath.setFillRule (Qt::WindingFill);

    drawPath (painter, pPath);
}

bool BGPath::closePath() const
{
    return ClosePath;
}

void BGPath::setClosePath(bool c)
{
    ClosePath = c;
    closePathChanged ();
}

bool BGPath::windingFill() const
{
    return WindingFill;
}

void BGPath::setWindingFill(bool wf)
{
    WindingFill = wf;
    windingFillChanged ();
}

void BGPath::appendElem(QQmlListProperty<BGPathElemBase>* list, BGPathElemBase* pe)
{
    qobject_cast < BGPath* > (list->object)->Elems.append (pe);
}

int BGPath::elemCount(QQmlListProperty<BGPathElemBase>* list)
{
    return qobject_cast < BGPath* > (list->object)->Elems.count ();
}

BGPathElemBase*BGPath::elem(QQmlListProperty<BGPathElemBase>* list, int i)
{
    return qobject_cast < BGPath* > (list->object)->Elems[i];
}

void BGPath::clearElems(QQmlListProperty<BGPathElemBase>* list)
{
    qobject_cast < BGPath* > (list->object)->Elems.clear ();
}

// class BGCanvas

BGCanvas::BGCanvas(QQuickItem *parent):
    QQuickPaintedItem (parent)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);
}

BGCanvas::~BGCanvas()
{
}

QQmlListProperty<BGPathBase> BGCanvas::paths()
{
    return QQmlListProperty < BGPathBase > (this, 0,
                                            &BGCanvas::appendPath,
                                            &BGCanvas::pathCount,
                                            &BGCanvas::path,
                                            &BGCanvas::clearPaths);
}

void BGCanvas::paint(QPainter* painter)
{
    painter->setRenderHints(QPainter::Antialiasing, true);
    foreach (BGPathBase* path, Paths) {
        path->draw (painter);
    }
}

void BGCanvas::requestPaint()
{
    update ();
}

/*void BGCanvas::appendPath(BGPathBase* path)
{
    Paths.append (path);
}

int BGCanvas::pathCount() const
{
    return Paths.count ();
}

BGPathBase* BGCanvas::path(int i) const
{
    return Paths[i];
}

void BGCanvas::clearPaths()
{
    Paths.clear ();
}*/

void BGCanvas::appendPath(QQmlListProperty<BGPathBase>* list, BGPathBase* p)
{
    qobject_cast < BGCanvas* > (list->object)->Paths.append (p);
}

int BGCanvas::pathCount(QQmlListProperty<BGPathBase>* list)
{
    return qobject_cast < BGCanvas* >(list->object)->Paths.count ();
}

BGPathBase* BGCanvas::path(QQmlListProperty<BGPathBase>* list, int i)
{
    return qobject_cast < BGCanvas* >(list->object)->Paths[i];
}

void BGCanvas::clearPaths(QQmlListProperty<BGPathBase>* list)
{
    qobject_cast < BGCanvas* > (list->object)->Paths.clear ();
}
