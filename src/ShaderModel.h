#ifndef SHADERMODEL_H
#define SHADERMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "ShaderItem.h"

class ShaderModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum ShaderRoles
    {
        ObjectRole = Qt::UserRole+1,
        NameRole,
        FragmentShaderRole,
        VertexShaderRole,
        ParametersRole
    };

    int count() const;

    ShaderModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QVariant get(const quint32 &shaderId) const;

signals:
    void countChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<ShaderItem *> _shaders;
    QString readFile(QString filename);

};

Q_DECLARE_METATYPE(ShaderModel *)

#endif // ShaderMODEL_H
