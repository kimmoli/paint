#include "helper.h"
#include <QQuickView>
#include <QWindow>

Helper::Helper(QObject *parent) :
    QObject(parent)
{
}

void Helper::setGestureOverride(bool override)
{
    QQuickView *view = static_cast<QQuickView*>(this->parent());

    if (override)
    {
        view->setFlags(view->flags() | Qt::WindowOverridesSystemGestures);
    }
    else
    {
        view->setFlags(view->flags() & ~(Qt::WindowOverridesSystemGestures));
    }
}
