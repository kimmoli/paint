/*
Copyright (c) 2014-2015 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "PainterClass.h"
#include <sailfishapp.h>
#include <QCoreApplication>
#include <QtQml>
#include <QGuiApplication>
#include <QFontDatabase>
#include <QImage>
#include <QTransform>
#include <QPainter>

PainterClass::PainterClass(QObject *parent) :
    QObject(parent)
{
    fontFamilies = QFontDatabase().families();
    _hl = 0;
    _hlDoc = 0;
}

QString PainterClass::readVersion()
{
    return APPVERSION;
}

PainterClass::~PainterClass()
{
}

QVariant PainterClass::getSetting(QString name, QVariant defaultValue)
{
    QSettings s("harbour-paint", "harbour-paint");
    s.beginGroup("Settings");
    QVariant settingValue = s.value(name, defaultValue);
    s.endGroup();

    return settingValue;
}

void PainterClass::setSetting(QString name, QVariant value)
{
    QSettings s("harbour-paint", "harbour-paint");
    s.beginGroup("Settings");
    s.setValue(name, value);
    s.endGroup();
}

int PainterClass::getToolSetting(QString name, int defaultValue)
{
    QSettings s("harbour-paint", "harbour-paint");
    s.beginGroup("Tools");
    int toolSettingValue = s.value(name, defaultValue).toInt();
    s.endGroup();

    return toolSettingValue;
}

void PainterClass::setToolSetting(QString name, int value)
{
    QSettings s("harbour-paint", "harbour-paint");
    s.beginGroup("Tools");
    s.setValue(name, value);
    s.endGroup();
}

QString PainterClass::getLanguage()
{
    return QLocale::system().name().split('_').at(0);
}

int PainterClass::getNumberOfFonts()
{
    return fontFamilies.count();
}

QString PainterClass::getFontName(int number)
{
    return fontFamilies.at(number);
}

void PainterClass::saveCanvas(QString dataURL1, QString background, bool bgRotate, int angle, QString filename, QList<int> cropArea)
{
    QImage s;
    s.loadFromData(QByteArray::fromBase64(dataURL1.split(",").at(1).toLatin1()), "png");

    if (!background.isEmpty())
    {
        if (QColor::isValidColor(background))
        {
            QPainter p;
            /* Fill background with solid color */
            p.begin(&s);
            p.setCompositionMode(QPainter::CompositionMode_DestinationOver);
            p.fillRect(s.rect(), QColor(background));
            p.end();
        }
        else
        {
            QImage bg(QUrl(background).toLocalFile());

            if (bgRotate)
            {
                QTransform tBg;
                tBg.rotate(90);
                QImage qBg = bg.transformed(tBg);
                bg = QImage(qBg);
            }

            /* Scale and center background image as it is done in qml */
            QRectF sRect(s.rect());

            qreal height = ((qreal)sRect.width()/(qreal)bg.rect().width()*(qreal)bg.rect().height());
            sRect.setTop( ((qreal)s.rect().height() - height) / 2);
            sRect.setBottom( (qreal)s.rect().height() - sRect.top());

            QPainter p;
            /* Draw background behind the canvas */
            p.begin(&s);
            p.setCompositionMode(QPainter::CompositionMode_DestinationOver);
            p.drawImage(sRect, bg, bg.rect());
            p.end();
        }
    }

    if (cropArea.at(2) > 0 && cropArea.at(3) > 0)
    {
        QRect crop(cropArea.at(0), cropArea.at(1), cropArea.at(2), cropArea.at(3));
        QImage cropped = s.copy(crop);
        s = QImage(cropped);
    }

    /* Rotate output according to device orientation */
    QTransform t;
    t.rotate((-1) * angle); // this is counterclockwise
    QImage q = s.transformed(t);

    QString ssFilename;

    if (filename.isEmpty())
    {
        QDate ssDate = QDate::currentDate();
        QTime ssTime = QTime::currentTime();

        ssFilename = QString("%7/paint-%1%2%3-%4%5%6.%8")
                        .arg((int) ssDate.day(),    2, 10, QLatin1Char('0'))
                        .arg((int) ssDate.month(),  2, 10, QLatin1Char('0'))
                        .arg((int) ssDate.year(),   2, 10, QLatin1Char('0'))
                        .arg((int) ssTime.hour(),   2, 10, QLatin1Char('0'))
                        .arg((int) ssTime.minute(), 2, 10, QLatin1Char('0'))
                        .arg((int) ssTime.second(), 2, 10, QLatin1Char('0'))
                        .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
                        .arg(getSetting("fileExtension", QVariant("png")).toString());
    }
    else
    {
        ssFilename = QString("%1/%2.%3")
                .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
                .arg(filename)
                .arg(getSetting("fileExtension", QVariant("png")).toString());
    }

    if (q.save(ssFilename))
        emit saveComplete(ssFilename.split('/').last());
    else
        emit saveComplete(QString());
}

bool PainterClass::fileExists(QString filename)
{
    QString filepath = QString("%1/%2.%3")
            .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
            .arg(filename)
            .arg(getSetting("fileExtension", QVariant("png")).toString());

    QFile test(filepath);

    return test.exists();
}

void PainterClass::setHighlightTarget(QQuickItem *target)
{
    if (_hl)
        delete _hl;

    _hlDoc = 0;
    _hl = 0;

    _hlTarget = target;

    if (!_hlTarget)
        return;

    QVariant doc = _hlTarget->property("textDocument");

    if (doc.canConvert<QQuickTextDocument*>())
    {
        QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();

        if (qqdoc) {
            _hlDoc = qqdoc->textDocument();
            _hl = new Highlighter(_hlDoc);

        }
    }
}
