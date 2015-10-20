#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <sailfishapp.h>
#include <QQuickImageProvider>
#include <QImageReader>
#include "nemoimagemetadata.h"

class ImageProvider : public QQuickImageProvider
{
public:
    ImageProvider() : QQuickImageProvider(QQuickImageProvider::Image)
    {
    }

    static QImage rotate(const QImage &src, NemoImageMetadata::Orientation orientation)
    {
        QTransform trans;
        QImage dst, tmp;

        /* For square images 90-degree rotations of the pixel could be
           done in-place, and flips could be done in-place for any image
           instead of using the QImage routines which make copies of the
           data. */

        switch (orientation)
        {
            case NemoImageMetadata::TopRight:
                /* horizontal flip */
                dst = src.mirrored(true, false);
                break;
            case NemoImageMetadata::BottomRight:
                /* horizontal flip, vertical flip */
                dst = src.mirrored(true, true);
                break;
            case NemoImageMetadata::BottomLeft:
                /* vertical flip */
                dst = src.mirrored(false, true);
                break;
            case NemoImageMetadata::LeftTop:
                /* rotate 90 deg clockwise and flip horizontally */
                trans.rotate(90.0);
                tmp = src.transformed(trans);
                dst = tmp.mirrored(true, false);
                break;
            case NemoImageMetadata::RightTop:
                /* rotate 90 deg anticlockwise */
                trans.rotate(90.0);
                dst = src.transformed(trans);
                break;
            case NemoImageMetadata::RightBottom:
                /* rotate 90 deg anticlockwise and flip horizontally */
                trans.rotate(-90.0);
                tmp = src.transformed(trans);
                dst = tmp.mirrored(true, false);
                break;
            case NemoImageMetadata::LeftBottom:
                /* rotate 90 deg clockwise */
                trans.rotate(-90.0);
                dst = src.transformed(trans);
                break;
            default:
                dst = src;
                break;
        }

        return dst;
    }

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(requestedSize)

        QString filename = QUrl(id).toString(QUrl::RemoveScheme);
        QImage img;
        QSize originalSize;
        QByteArray format;
        QImageReader ir(filename);

        if (!ir.canRead())
            return img;

        originalSize = ir.size();
        format = ir.format();

        if (size)
            *size = originalSize;

        img = ir.read();

        NemoImageMetadata meta(filename, format);

        if (meta.orientation() != NemoImageMetadata::TopLeft)
            img = rotate(img, meta.orientation());

        return img;
    }
};

#endif // IMAGEPROVIDER_H
