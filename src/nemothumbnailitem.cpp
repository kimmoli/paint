/*
 * Copyright (C) 2012 Jolla Ltd
 * Contact: Andrew den Exter <andrew.den.exter@jollamobile.com>
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

#include "nemothumbnailitem.h"

#include "nemothumbnailprovider.h"

#include "linkedlist.h"

#include <QCoreApplication>

#include <QSGGeometryNode>
#include <QSGTextureMaterial>
#include <QQuickWindow>

class ThumbnailNode : public QSGGeometryNode
{
public:
    ThumbnailNode();
    ~ThumbnailNode();

    QSGGeometry geometry;
    QSGTextureMaterial material;
};

ThumbnailNode::ThumbnailNode()
    : geometry(QSGGeometry::defaultAttributes_TexturedPoint2D(), 4)
{
    setGeometry(&geometry);
    setMaterial(&material);
}

ThumbnailNode::~ThumbnailNode()
{
    delete material.texture();
}

template <typename T, int N> static int lengthOf(const T(&)[N]) { return N; }

ThumbnailRequest::ThumbnailRequest(NemoThumbnailItem *item, const QString &fileName, const QByteArray &cacheKey)
    : cacheKey(cacheKey)
    , fileName(fileName)
    , mimeType(item->m_mimeType)
    , size(item->m_sourceSize)
    , fillMode(item->m_fillMode)
    , status(NemoThumbnailItem::Loading)
    , priority(NemoThumbnailItem::Unprioritized)
    , loading(false)
    , loaded(false)
{
}

ThumbnailRequest::~ThumbnailRequest()
{
}

NemoThumbnailItem::NemoThumbnailItem(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_request(0)
    , m_priority(NormalPriority)
    , m_fillMode(PreserveAspectCrop)
    , m_imageChanged(false)
{
    setFlag(QQuickItem::ItemHasContents, true);
}

NemoThumbnailItem::~NemoThumbnailItem()
{
    if (m_request)
        NemoThumbnailLoader::instance->cancelRequest(this);
}

void NemoThumbnailItem::componentComplete()
{
    QDeclarativeItem::componentComplete();

    updateThumbnail(true);
}

QUrl NemoThumbnailItem::source() const
{
    return m_source;
}

void NemoThumbnailItem::setSource(const QUrl &source)
{
    if (m_source != source) {
        m_source = source;
        emit sourceChanged();
        updateThumbnail(true);
    }
}

QString NemoThumbnailItem::mimeType() const
{
    return m_mimeType;
}

void NemoThumbnailItem::setMimeType(const QString &mimeType)
{
    if (m_mimeType != mimeType) {
        m_mimeType = mimeType;
        emit mimeTypeChanged();
        updateThumbnail(!m_request);
    }
}

NemoThumbnailItem::Priority NemoThumbnailItem::priority() const
{
    return m_priority;
}

void NemoThumbnailItem::setPriority(Priority priority)
{
    if (m_priority != priority) {
        m_priority = priority;
        emit priorityChanged();
        if (m_request)
            NemoThumbnailLoader::instance->updateRequest(this, false);
    }
}

QSize NemoThumbnailItem::sourceSize() const
{
    return m_sourceSize;
}

void NemoThumbnailItem::setSourceSize(const QSize &size)
{
    if (m_sourceSize != size) {
        m_sourceSize = size;
        emit sourceSizeChanged();
        updateThumbnail(true);
    }
}

NemoThumbnailItem::FillMode NemoThumbnailItem::fillMode() const
{
    return m_fillMode;
}

void NemoThumbnailItem::setFillMode(FillMode mode)
{
    if (m_fillMode != mode) {
        m_fillMode = mode;
        emit fillModeChanged();
        updateThumbnail(true);
    }
}

NemoThumbnailItem::Status NemoThumbnailItem::status() const
{
    return m_request ? m_request->status : Null;
}

QSGNode *NemoThumbnailItem::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    ThumbnailNode *node = static_cast<ThumbnailNode *>(oldNode);
    if (!m_request || m_request->pixmap.isNull()) {
        delete node;
        return 0;
    }

    if (!node)
        node = new ThumbnailNode;


    if (m_imageChanged || !node->material.texture()) {
        m_imageChanged = false;
        delete node->material.texture();
        node->material.setTexture(window()->createTextureFromImage(m_request->pixmap));
        node->markDirty(QSGNode::DirtyMaterial);
    }

    QRectF rect(QPointF(0, 0), m_request->pixmap.size().scaled(
                width(),
                height(),
                m_fillMode == PreserveAspectFit ? Qt::KeepAspectRatio : Qt::KeepAspectRatioByExpanding));
    rect.moveCenter(QPointF(width() / 2, height() / 2));

    QSGGeometry::updateTexturedRectGeometry(
                &node->geometry,
                rect,
                node->material.texture()->normalizedTextureSubRect());
    node->markDirty(QSGNode::DirtyGeometry);

    return node;
}

void NemoThumbnailItem::updateThumbnail(bool identityChanged)
{
    if (!isComponentComplete())
        return;

    Status status = m_request ? m_request->status : Null;

    if (m_source.isLocalFile() && !m_sourceSize.isEmpty())
        NemoThumbnailLoader::instance->updateRequest(this, identityChanged);
    else if (m_request)
        NemoThumbnailLoader::instance->cancelRequest(this);

    if (status != (m_request ? m_request->status : Null))
        emit statusChanged();
}

NemoThumbnailLoader *NemoThumbnailLoader::instance = 0;

static int thumbnailerMaxCost()
{
    const QByteArray costEnv = qgetenv("NEMO_THUMBNAILER_CACHE_SIZE");

    bool ok = false;
    int cost = costEnv.toInt(&ok);
    return ok ? cost : 1360 * 768 * 3;
}

NemoThumbnailLoader::NemoThumbnailLoader(QObject *parent)
    : QThread(parent)
    , m_totalCost(0)
    , m_maxCost(thumbnailerMaxCost())
    , m_quit(false)
{
    Q_ASSERT(!instance);
    instance = this;
}

NemoThumbnailLoader::~NemoThumbnailLoader()
{
    instance = 0;
}

void NemoThumbnailLoader::updateRequest(NemoThumbnailItem *item, bool identityChanged)
{
    ThumbnailRequest *previousRequest = item->m_request;
    // If any property that forms part of the cacheKey has changed, create a new request or
    // attach to an existing request for the same cacheKey.
    if (identityChanged) {
        item->listNode.erase();

        const QString fileName = item->m_source.toLocalFile();
        QByteArray cacheKey = NemoThumbnailProvider::cacheKey(fileName, item->m_sourceSize);
        if (item->m_fillMode == NemoThumbnailItem::PreserveAspectFit)
            cacheKey += 'F';

        item->m_request = m_requestCache.value(cacheKey);

        if (!item->m_request) {
            item->m_request = new ThumbnailRequest(item, fileName, cacheKey);
            m_requestCache.insert(cacheKey, item->m_request);
        }
        item->m_request->items.append(item);

        // If an existing request is already completed, push it to the back of the cached requests
        // lists to renew it and update the item.
        if (item->m_request->status == NemoThumbnailItem::Ready) {
            m_cachedRequests.append(item->m_request);

            item->m_imageChanged = true;
            item->setImplicitWidth(item->m_request->pixmap.width());
            item->setImplicitHeight(item->m_request->pixmap.height());
            emit item->statusChanged();
            item->update();
            return;
        }
    }

    // If the cache is full release excess unreferenced items.
    ThumbnailRequestList::iterator it = m_cachedRequests.begin();
    while (m_totalCost > m_maxCost && it != m_cachedRequests.end()) {
        if (it->items.isEmpty()) {
            ThumbnailRequest *cachedRequest = it;
            it = m_cachedRequests.erase(it);
            m_totalCost -= cachedRequest->pixmap.width() * cachedRequest->pixmap.height();
            m_requestCache.remove(cachedRequest->cacheKey);
            delete cachedRequest;
        } else {
            ++it;
        }
    }

    QMutexLocker locker(&m_mutex);

    // If the item's existing request was replaced, destroy or reprioritize if it is referenced
    // by other items.
    if (previousRequest != item->m_request && previousRequest)
        prioritizeRequest(previousRequest);

    prioritizeRequest(item->m_request);

    m_waitCondition.wakeOne();
}

void NemoThumbnailLoader::cancelRequest(NemoThumbnailItem *item)
{
    ThumbnailRequest *request = item->m_request;
    Q_ASSERT(request);

    // Remove the item from the request list.
    item->listNode.erase();
    item->m_request = 0;

    // Destroy or reprioritize the request as appropriate.
    QMutexLocker locker(&m_mutex);
    prioritizeRequest(request);
}

void NemoThumbnailLoader::prioritizeRequest(ThumbnailRequest *request)
{
    if (request->loaded)
        return;

    ThumbnailRequestList *lists[] = {
        &m_thumbnailHighPriority, &m_thumbnailNormalPriority, &m_thumbnailLowPriority
    };

    NemoThumbnailItem::Priority priority = NemoThumbnailItem::LowPriority;
    for (ThumbnailItemList::iterator it = request->items.begin(); it !=  request->items.end(); ++it)
        priority = qMin(priority, it->m_priority);

    if (request->items.isEmpty()) {
        // Cancel a pending request with no target items unless it's currently being loaded in
        // which case let it complete as it will either just be cached or appended to the low
        // priority generate queue.
        if (!request->loading) {
            m_requestCache.remove(request->cacheKey);
            delete request;
        }
    } else if (request->priority != priority) {
        request->priority = priority;
        if (!request->loading)
            lists[priority]->append(request);
    }
}

void NemoThumbnailLoader::shutdown()
{
    if (!instance)
        return;

    {
        QMutexLocker locker(&instance->m_mutex);

        instance->m_quit = true;

        instance->m_waitCondition.wakeOne();
    }

    instance->wait();

    ThumbnailRequestList *lists[] = {
        &instance->m_thumbnailHighPriority,
        &instance->m_thumbnailNormalPriority,
        &instance->m_thumbnailLowPriority,
        &instance->m_generateHighPriority,
        &instance->m_generateNormalPriority,
        &instance->m_generateLowPriority,
        &instance->m_completedRequests,
        &instance->m_cachedRequests
    };

    for (int i = 0; i < lengthOf(lists); ++i) {
        while (ThumbnailRequest *request = lists[i]->takeFirst())
            delete request;
    }

    delete instance;
}

bool NemoThumbnailLoader::event(QEvent *event)
{
    if (event->type() == QEvent::User) {
        // Move items from the completedRequests list to cachedRequests.
        ThumbnailRequestList completedRequests;
        {
            QMutexLocker locker(&m_mutex);
            completedRequests = m_completedRequests;
        }

        while (ThumbnailRequest *request = completedRequests.takeFirst()) {
            m_cachedRequests.append(request);

            // Update any items associated with the request.
            const QSize implicitSize = request->image.size();
            if (!request->image.isNull()) {
                request->pixmap = request->image;
                request->image = QImage();
                request->status = NemoThumbnailItem::Ready;

                m_totalCost += implicitSize.width() * implicitSize.height();
            } else {
                request->pixmap = QImage();
                request->image = QImage();

                request->status = NemoThumbnailItem::Error;
            }
            for (ThumbnailItemList::iterator item = request->items.begin();
                    item != request->items.end();
                    ++item) {
                item->m_imageChanged = true;
                item->setImplicitWidth(implicitSize.width());
                item->setImplicitHeight(implicitSize.height());
                emit item->statusChanged();
                item->update();
            }
        }

        return true;
    } else {
        return NemoThumbnailLoader::event(event);
    }
}

void NemoThumbnailLoader::run()
{
    NemoThumbnailProvider::setupCache();

    QMutexLocker locker(&m_mutex);

    for (;;) {
        ThumbnailRequest *request = 0;
        bool tryCache;

        // Grab the next request in priority order.  High and normal priority thumbnails are
        // prioritized over generating any thumbnail, and low priority loading or generation
        // is deprioritized over everything else.
        if (m_quit) {
            return;
        } else if ((request = m_thumbnailHighPriority.takeFirst())
                || (request = m_thumbnailNormalPriority.takeFirst())) {
            tryCache = true;
        } else if ((request = m_generateHighPriority.takeFirst())
                || (request = m_generateNormalPriority.takeFirst())) {
            tryCache = false;
        } else if ((request = m_thumbnailLowPriority.takeFirst())) {
            tryCache = true;
        } else if ((request = m_generateLowPriority.takeFirst())) {
            tryCache = false;
        } else {
            m_waitCondition.wait(&m_mutex);
            continue;
        }

        Q_ASSERT(request);
        const QByteArray cacheKey = request->cacheKey;
        const QString fileName = request->fileName;
        const QString mimeType = request->mimeType;
        const QSize requestedSize = request->size;
        const bool crop = request->fillMode == NemoThumbnailItem::PreserveAspectCrop;
        const bool landscape = request->fillMode == NemoThumbnailItem::RotateFit;

        request->loading = true;

        locker.unlock();

        if (tryCache) {
            QImage image = NemoThumbnailProvider::loadThumbnail(fileName, cacheKey);

            locker.relock();
            request->loading = false;

            if (!image.isNull()) {
                request->loaded = true;
                request->image = image;
                if (m_completedRequests.isEmpty())
                    QCoreApplication::postEvent(this, new QEvent(QEvent::User));
                m_completedRequests.append(request);
            } else {
                ThumbnailRequestList *lists[] = {
                    &m_generateHighPriority, &m_generateNormalPriority, &m_generateLowPriority
                };
                lists[request->priority]->append(request);
            }
        } else {
            QImage image = NemoThumbnailProvider::generateThumbnail(fileName, cacheKey, requestedSize, crop, landscape);

            locker.relock();
            request->loading = false;
            request->loaded = true;
            request->image = image;
            if (m_completedRequests.isEmpty())
                QCoreApplication::postEvent(this, new QEvent(QEvent::User));
            m_completedRequests.append(request);
        }
    }
}
