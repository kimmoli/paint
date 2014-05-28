/*
Copyright (c) 2014 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "myclass.h"
#include <QCoreApplication>
#include <QtDBus/QtDBus>
#include <QDBusArgument>

Myclass::Myclass(QObject *parent) :
    QObject(parent)
{
}

QString Myclass::readVersion()
{
    return APPVERSION;
}


Myclass::~Myclass()
{
}


QString Myclass::saveScreenshot()
{
    QDate ssDate = QDate::currentDate();
    QTime ssTime = QTime::currentTime();

    QString ssFilename = QString("%7/paint-%1%2%3-%4%5%6.png")
                    .arg((int) ssDate.day(),    2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.month(),  2, 10, QLatin1Char('0'))
                    .arg((int) ssDate.year(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.hour(),   2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.minute(), 2, 10, QLatin1Char('0'))
                    .arg((int) ssTime.second(), 2, 10, QLatin1Char('0'))
                    .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation));

    QDBusMessage m = QDBusMessage::createMethodCall("org.nemomobile.lipstick",
                                                    "/org/nemomobile/lipstick/screenshot",
                                                    "",
                                                    "saveScreenshot" );

    QList<QVariant> args;
    args.append(ssFilename);
    m.setArguments(args);

    if (QDBusConnection::sessionBus().send(m))
    {
        printf("Screenshot success to %s\n", qPrintable(ssFilename));
        return ssFilename.split('/').last();
    }
    else
    {
        printf("Screenshot failed\n");
        return QString("Failed");
    }


}


