/*
 * Copyright (C) 2012 Robin Burchell <robin+nemo@viroteck.net>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

#include <QFile>
#include <QCryptographicHash>
#include <QDebug>
#include <QDir>
#include <QImageReader>
#include <QDateTime>
#include <QtEndian>
#include <QElapsedTimer>

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
# include <QStandardPaths>
#else
# include <QDesktopServices>
#endif

#undef THUMBNAILER_DEBUG

#ifdef THUMBNAILER_DEBUG
#define TDEBUG qDebug
#else
#define TDEBUG if(false)qDebug
#endif

#include "nemoimagemetadata.h"
#include "nemothumbnailprovider.h"

static inline QString cachePath()
{
#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
    return QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation) + "/.nemothumbs";
#else
    return QDesktopServices::storageLocation(QDesktopServices::CacheLocation) + ".nemothumbs";
#endif
}

static inline QString rawCachePath()
{
    return cachePath() + QDir::separator() + "raw";
}

void NemoThumbnailProvider::setupCache()
{
    // the syscalls make baby jesus cry; but this protects us against sins like users
    QDir d(cachePath());
    if (!d.exists())
        d.mkpath(cachePath());
    d.mkdir("raw");

    // in the future, we might store a nicer UI version which can blend in with our UI better, but
    // we'll always want the raw version.
}

static QString cacheFileName(const QByteArray &hashKey, bool makePath = false)
{
    QString subfolder = QString(hashKey.left(2));
    if (makePath) {
        QDir d(rawCachePath());
        d.mkdir(subfolder);
    }

    return rawCachePath() +
           QDir::separator() +
           subfolder +
           QDir::separator() +
           hashKey;
}

QByteArray NemoThumbnailProvider::cacheKey(const QString &id, const QSize &requestedSize)
{
    QByteArray baId = id.toLatin1(); // is there a more efficient way than a copy?

    // check if we have it in cache
    QCryptographicHash hash(QCryptographicHash::Sha1);

    hash.addData(baId.constData(), baId.length());
    return hash.result().toHex() + "nemo" +
           QString::number(requestedSize.width()).toLatin1() + "x" +
           QString::number(requestedSize.height()).toLatin1();
}

static QImage attemptCachedServe(const QString &id, const QByteArray &hashKey)
{
    QFile fi(cacheFileName(hashKey));
    QFileInfo info(fi);
    if (info.exists() && info.lastModified() >= QFileInfo(id).lastModified()) {
        if (fi.open(QIODevice::ReadOnly)) {
            // cached file exists! hooray.
            QImage img;
            img.load(&fi, "JPG");
            return img;
        }
    }

    return QImage();
}

void NemoThumbnailProvider::writeCacheFile(const QByteArray &hashKey, const QImage &img)
{
    QFile fi(cacheFileName(hashKey, true));
    if (!fi.open(QIODevice::WriteOnly)) {
        qWarning() << "Couldn't cache to " << fi.fileName();
        return;
    }
    img.save(&fi, "JPG");
    fi.flush();
    fi.close();
}

static QImage rotate(const QImage &src,
                     NemoImageMetadata::Orientation orientation)
{
    QTransform trans;
    QImage dst, tmp;

    /* For square images 90-degree rotations of the pixel could be
       done in-place, and flips could be done in-place for any image
       instead of using the QImage routines which make copies of the
       data. */

    switch (orientation) {
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

QImage NemoThumbnailProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    setupCache();

    // needed for stupid things like gallery model, which pass us a url
    if (id.startsWith("file://")) {
//        qWarning() << Q_FUNC_INFO << "Removing file:// prefix, before: " << id;
        QString &nid = const_cast<QString &>(id);
        nid = nid.remove(0, 7);
    }

    TDEBUG() << Q_FUNC_INFO << "Requested image: " << id << " with size " << requestedSize;

    // sourceSize should indicate what size thumbnail you want. i.e. if you want a 120x120px thumbnail,
    // set sourceSize: Qt.size(120, 120).
    if (!requestedSize.isValid())
        qFatal("You must request a sourceSize whenever you use nemoThumbnail");

    if (size)
        *size = requestedSize;

    QByteArray hashData = cacheKey(id, requestedSize);
    QImage img = attemptCachedServe(id, hashData);
    if (!img.isNull()) {
        TDEBUG() << Q_FUNC_INFO << "Read " << id << " from cache";
        return img;
    }

    return generateThumbnail(id, hashData, requestedSize);
}

QImage NemoThumbnailProvider::loadThumbnail(const QString &fileName, const QByteArray &cacheKey)
{
    return ::attemptCachedServe(fileName, cacheKey);
}

QImage NemoThumbnailProvider::generateThumbnail(const QString &id, const QByteArray &hashData, const QSize &requestedSize, bool crop, bool landscape)
{
    QImage img;
    QSize originalSize;
    QByteArray format;

    QSize _requestedSize(requestedSize);

    if (landscape)
        _requestedSize.transpose();

    // image was not in cache thus we read it
    QImageReader ir(id);
    if (!ir.canRead())
        return img;

    originalSize = ir.size();
    format = ir.format();

    if (originalSize != _requestedSize && originalSize.isValid())
    {
        if (crop)
        {
            // scales arbitrary sized source image to requested size scaling either up or down
            // keeping aspect ratio of the original image intact by maximizing either width or height
            // and cropping the rest of the image away
            QSize scaledSize(originalSize);

            // now scale it filling the original rectangle by keeping aspect ratio, but expand if needed.
            scaledSize.scale(_requestedSize, Qt::KeepAspectRatioByExpanding);

            // set the adjusted clipping rectangle in the center of the scaled image
            QPoint center((scaledSize.width() - 1) / 2, (scaledSize.height() - 1) / 2);
            QRect cr(0, 0, _requestedSize.width(), _requestedSize.height());
            cr.moveCenter(center);
            ir.setScaledClipRect(cr);

            // set requested target size of a thumbnail
            ir.setScaledSize(scaledSize);
        }
        else
        {
            // Maintains correct aspect ratio without cropping, as such the final image may
            // be smaller than requested in one dimension.
            QSize scaledSize(originalSize);
            scaledSize.scale(_requestedSize, Qt::KeepAspectRatio);
            ir.setScaledSize(scaledSize);
        }
    }
    img = ir.read();

    NemoImageMetadata meta(id, format);
    if (meta.orientation() != NemoImageMetadata::TopLeft)
        img = rotate(img, meta.orientation());

    /* If requested landscape image, rotate once 90 degrees clockwise */
    if (landscape)
        img = rotate(img, NemoImageMetadata::RightTop);

    // write the scaled image to cache
    if (meta.orientation() != NemoImageMetadata::TopLeft || (originalSize != _requestedSize && originalSize.isValid()))
    {
        writeCacheFile(hashData, img);
    }

    TDEBUG() << Q_FUNC_INFO << "Wrote " << id << " to cache";
    return img;
}
