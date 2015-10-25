/*
Copyright (c) 2014-2015 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef PainterClass_H
#define PainterClass_H
#include <QObject>
#include <QVariant>
#include <QStringList>
#include <QList>

class PainterClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString version READ readVersion NOTIFY versionChanged())
    Q_ENUMS(Mode)
    Q_ENUMS(GeometricsMode)

public:
    explicit PainterClass(QObject *parent = 0);
    ~PainterClass();

    QString readVersion();

    Q_INVOKABLE QVariant getSetting(QString name, QVariant defaultValue);
    Q_INVOKABLE void setSetting(QString name, QVariant value);
    Q_INVOKABLE int getToolSetting(QString name, int defaultValue);
    Q_INVOKABLE void setToolSetting(QString name, int value);

    Q_INVOKABLE QString getLanguage();
    Q_INVOKABLE int getNumberOfFonts();
    Q_INVOKABLE QString getFontName(int number);

    Q_INVOKABLE void saveCanvas(QString dataURL1,
                                QString background,
                                bool bgRotate,
                                int angle,
                                QString filename,
                                QList<int> cropArea);

    Q_INVOKABLE bool fileExists(QString filename);

    enum Mode
    {
        None = -1,
        Eraser = 0,
        Pen,
        Spray,
        Geometrics,
        Text,
        Dimensioning,
        Image,
        Crop,
        Clipboard
    };

    enum GeometricsMode
    {
        Line = 0,
        Rectangle,
        Circle,
        Ellipse,
        Square,
        EquilateralTriangle,
        RightIsoscelesTriangle,
        Polygon,
        Polygram,
        Arrow,
        FreehandClosed
    };

signals:
    void versionChanged();
    void saveComplete(QString filename);

private:
    QStringList fontFamilies;

};


#endif // PainterClass_H

