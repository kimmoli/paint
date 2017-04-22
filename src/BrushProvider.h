#ifndef BRUSHPROVIDER_H
#define BRUSHPROVIDER_H

#include <sailfishapp.h>
#include <QQuickImageProvider>
#include <QPainter>
#include <QColor>

class BrushProvider : public QQuickImageProvider
{
public:
    BrushProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
    {
    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        QStringList parts = id.split('?');

        QPixmap sourcePixmap(SailfishApp::pathTo("qml/brush/" + parts.at(0) + ".png").toString(QUrl::RemoveScheme));

        if (sourcePixmap.isNull())
            return QPixmap();

        if (size)
            *size  = sourcePixmap.size();

        if (parts.length() > 1)
            if (QColor::isValidColor(parts.at(1)))
            {
                QPainter painter(&sourcePixmap);
                painter.setCompositionMode(QPainter::CompositionMode_SourceIn);
                painter.fillRect(sourcePixmap.rect(), parts.at(1));
                painter.end();
            }

        if (requestedSize.isValid())
            return sourcePixmap.scaled(requestedSize.width(), requestedSize.height(), Qt::IgnoreAspectRatio);
        else
            return sourcePixmap;
    }
};

#endif // BRUSHPROVIDER_H
