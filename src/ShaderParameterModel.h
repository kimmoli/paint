#ifndef SHADERPARAMETERMODEL_H
#define SHADERPARAMETERMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "ShaderParameterItem.h"

class ShaderParameterModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum ShaderParameterRoles
    {
        ObjectRole = Qt::UserRole+1,
        NameRole,
        MinRole,
        MaxRole,
        StepRole,
        NowRole
    };

    int count() const;

    ShaderParameterModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    void append(ShaderParameterItem * const p);
    void append(const QString name, const double min, const double max, const double step = 0.01);
    Q_INVOKABLE QVariant get(const quint32 &paramId) const;

signals:
    void countChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ShaderParameterItem *> _shaderParameters;

};

Q_DECLARE_METATYPE(ShaderParameterModel *)

#endif // SHADERPARAMETERMODEL_H
