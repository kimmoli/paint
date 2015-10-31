#include <sailfishapp.h>
#include "ShaderItem.h"

ShaderItem::ShaderItem(QObject *parent)
    : QObject(parent), _name(QString()), _fragmentShader(QString()), _vertexShader(QString()), _parameters(0)
{
}

QString ShaderItem::name() const
{
    return _name;
}
void ShaderItem::setName(const QString &n)
{
    _name = n;
    emit nameChanged();
}

QString ShaderItem::fragmentShader() const
{
    return _fragmentShader;
}
void ShaderItem::setFragmentShader(const QString &f)
{
    _fragmentShader = f;
    emit fragmentShaderChanged();
}

QString ShaderItem::vertexShader() const
{
    return _vertexShader;
}
void ShaderItem::setVertexShader(const QString &v)
{
    _vertexShader = v;
    emit vertexShaderChanged();
}

QVariant ShaderItem::parameters() const
{
    if (_parameters == 0)
        return QVariant();

    return QVariant::fromValue<ShaderParameterModel *>(_parameters);
}

void ShaderItem::addParameters(ShaderParameterModel * const p)
{
    _parameters = p;
}
