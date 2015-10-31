/*
Copyright (c) 2014-2015 kimmoli kimmo.lindholm@gmail.com @likimmo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <sailfishapp.h>
#include <QtQml>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QCoreApplication>
#include "PainterClass.h"
#include "IconProvider.h"
#include "ImageProvider.h"
#include "BrushProvider.h"
#include "BrushModel.h"
#include "ShaderModel.h"
#include "helper.h"

QList<int> GetSailfishVersion();

int main(int argc, char *argv[])
{
    qmlRegisterType<PainterClass>("harbour.paint.PainterClass", 1, 0, "Painter");

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    QTranslator translator;
    translator.load(QLocale::system().name(), SailfishApp::pathTo("i18n").toString(QUrl::RemoveScheme));
    app->installTranslator(&translator);

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QQmlEngine *engine = view->engine();
    engine->addImageProvider(QLatin1String("paintIcons"), new IconProvider);
    engine->addImageProvider(QLatin1String("paintImage"), new ImageProvider);
    engine->addImageProvider(QLatin1String("paintBrush"), new BrushProvider);

    Helper *helper = new Helper(view.data());
    view->rootContext()->setContextProperty("helper", helper);

    BrushModel *bm = new BrushModel();
    view->rootContext()->setContextProperty("Brushes", bm);

    ShaderModel *sm = new ShaderModel();
    view->rootContext()->setContextProperty("Shaders", sm);

    view->setSource(SailfishApp::pathTo("qml/paint.qml"));

    if (GetSailfishVersion().at(1) > 0 || GetSailfishVersion().at(0) > 1)
    {
        /* Revert some defaults due Sailfish moving to Qt5.2 not to allow releasing graphics resources.
         * source https://lists.sailfishos.org/pipermail/devel/2014-May/004123.html */
        view->setPersistentOpenGLContext(true);
        view->setPersistentSceneGraph(true);
    }

    view->show();

    return app->exec();
}

QList<int> GetSailfishVersion()
{
    QList<int> version;

    version << -1 << -1 << -1 << -1;

    QFile inputFile( "/etc/sailfish-release" );

    if ( inputFile.open( QIODevice::ReadOnly | QIODevice::Text ) )
    {
       QTextStream in( &inputFile );

       while (not in.atEnd())
       {
           QString line = in.readLine();
           if (line.startsWith("VERSION_ID="))
           {
               version.clear();
               foreach (QString tmp, line.split('=').at(1).split('.'))
               {
                   version << tmp.toInt();
               }
               break;
           }
       }
       inputFile.close();
    }

    return version;
}


