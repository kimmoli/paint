/*
Copyright (c) 2014 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "myclass.h"
#include <QSettings>
#include <QCoreApplication>

Myclass::Myclass(QObject *parent) :
    QObject(parent)
{
    m_var = "";

    emit versionChanged();
}

QString Myclass::readVersion()
{
    return APPVERSION;
}

void Myclass::readInitParams()
{
    QSettings settings;
    m_var = settings.value("var", "").toString();

    emit varChanged();
}

Myclass::~Myclass()
{
}


QString Myclass::readVar()
{
    return m_var;
}

void Myclass::writeVar(QString s)
{
    m_var = s;

    QSettings settings;
    settings.setValue("var", m_var);

    emit varChanged();
}



