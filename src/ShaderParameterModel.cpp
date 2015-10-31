#include <QQmlEngine>
#include "ShaderParameterModel.h"

ShaderParameterModel::ShaderParameterModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ShaderParameterModel::count() const
{
    return _shaderParameters.count();
}

int ShaderParameterModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return _shaderParameters.count();
}

QVariant ShaderParameterModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= _shaderParameters.count())
        return QVariant();

    ShaderParameterItem *parameter = _shaderParameters.at(index.row());

    switch (role)
    {
    case ObjectRole:
        return QVariant::fromValue<ShaderParameterItem *>(parameter);
        break;
    case NameRole:
        return parameter->name();
        break;
    case MinRole:
        return parameter->min();
        break;
    case MaxRole:
        return parameter->max();
        break;
    case NowRole:
        return parameter->now();
        break;

    default:
        return QVariant();
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> ShaderParameterModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[ObjectRole] = "object";
    roles[NameRole] =   "name";
    roles[MinRole] =    "min";
    roles[MaxRole] =    "max";
    roles[NowRole] =    "now";

    return roles;
}

QVariant ShaderParameterModel::get(const quint32 &paramId) const
{
    if (paramId > (quint32)_shaderParameters.count())
        return QVariant();

    ShaderParameterItem * parameter = _shaderParameters.at(paramId);
    QQmlEngine::setObjectOwnership(parameter, QQmlEngine::CppOwnership);
    return QVariant::fromValue<ShaderParameterItem *>(parameter);
}

void ShaderParameterModel::append(ShaderParameterItem * const p)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    _shaderParameters.append(p);

    endInsertRows();

    emit countChanged();
}

void ShaderParameterModel::append(const QString name, const double min, const double max)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    ShaderParameterItem *param = new ShaderParameterItem();
    QQmlEngine::setObjectOwnership(param, QQmlEngine::CppOwnership);
    param->setName(name);
    param->setMin(min);
    param->setMax(max);
    param->setNow((min + max)/2.0);

    _shaderParameters.append(param);

    endInsertRows();

    emit countChanged();
}
