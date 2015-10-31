#include "ShaderParameterItem.h"

ShaderParameterItem::ShaderParameterItem(QObject *parent) :
    QObject(parent), _name(QString()), _min(0.0), _max(1.0), _now(0.0)
{
}

QString ShaderParameterItem::name() const
{
    return _name;
}
void ShaderParameterItem::setName(const QString &n)
{
    _name = n;
    emit nameChanged();
}

double ShaderParameterItem::min() const
{
    return _min;
}
void ShaderParameterItem::setMin(const double &v)
{
    _min = v;
    emit minChanged();
}

double ShaderParameterItem::max() const
{
    return _max;
}
void ShaderParameterItem::setMax(const double &v)
{
    _max = v;
    emit maxChanged();
}

double ShaderParameterItem::now() const
{
    return _now;
}
void ShaderParameterItem::setNow(const double &v)
{
    _now = v;
    emit nowChanged();
}
