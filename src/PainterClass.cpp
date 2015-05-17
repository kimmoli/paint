/*
Copyright (c) 2014-2015 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "PainterClass.h"
#include <QCoreApplication>
#include <QtDBus/QtDBus>
#include <QDBusArgument>
#include <QFontDatabase>
#include <QImage>
#include <QTransform>

PainterClass::PainterClass(QObject *parent) :
    QObject(parent)
{
    fontFamilies = QFontDatabase().families();
}

QString PainterClass::readVersion()
{
    return APPVERSION;
}

PainterClass::~PainterClass()
{
}

QString PainterClass::saveScreenshot()
{
    QDate ssDate = QDate::currentDate();
    QTime ssTime = QTime::currentTime();

    QString ssFilename = QString("%7/paint-%1%2%3-%4%5%6.%8")
                    .arg((int) ssDate.day(),    2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.month(),  2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.year(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.hour(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.minute(), 2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.second(), 2, 10, QLatin1Char('0'))
                    .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
                    .arg(getSetting("fileExtension", QVariant("png")).toString());

    QDBusMessage m = QDBusMessage::createMethodCall("org.nemomobile.lipstick",
                                                    "/org/nemomobile/lipstick/screenshot",
                                                    "",
                                                    "saveScreenshot" );

    QList<QVariant> args;
    args.append(ssFilename);
    m.setArguments(args);

    if (QDBusConnection::sessionBus().send(m))
    {
        qDebug() << "Screenshot success to" << qPrintable(ssFilename);
        return ssFilename.split('/').last();
    }
    else
    {
        qWarning() << "Screenshot failed";
        return QString("Failed");
    }


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

QString PainterClass::saveCanvas(QString dataURL, int angle)
{
    // QTransform is counterclockwise
    if (angle == 90 || angle == -90)
        angle = angle * (-1);

    QImage p;
    p.loadFromData(QByteArray::fromBase64(dataURL.split(",").at(1).toLatin1()), "png");

    QTransform t;
    t.rotate(angle);
    QImage q = p.transformed(t);

    QDate ssDate = QDate::currentDate();
    QTime ssTime = QTime::currentTime();

    QString ssFilename = QString("%7/paint-%1%2%3-%4%5%6.%8")
                    .arg((int) ssDate.day(),    2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.month(),  2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.year(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.hour(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.minute(), 2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.second(), 2, 10, QLatin1Char('0'))
                    .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
                    .arg(getSetting("fileExtension", QVariant("png")).toString());

    if (q.save(ssFilename))
        return ssFilename.split('/').last();
    else
        return QString();
}
