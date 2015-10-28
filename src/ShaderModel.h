#ifndef SHADERMODEL_H
#define SHADERMODEL_H

#include <QAbstractListModel>
#include <QStringList>
#include <QVariantList>

class Shader
{
public:
    Shader(const QString &name, const QString &fragment, const QString &vertex, const QVariantList &params);

    QString name() const;
    QString fragment() const;
    QString vertex() const;
    QVariantList params() const;

private:
    QString _name;
    QString _fragment;
    QString _vertex;
    QVariantList _params;
};

class ShaderModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ShaderRoles
    {
        NameRole = Qt::UserRole+1,
        FragmentRole,
        VertexRole,
        ParamsRole
    };

    ShaderModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QString getName(quint32 shaderId) const;
    Q_INVOKABLE QString getFragmentShader(quint32 shaderId) const;
    Q_INVOKABLE QString getVertexShader(quint32 shaderId) const;
    Q_INVOKABLE QVariantList getParameters(quint32 shaderId) const;

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Shader> _shaders;
    QString readFile(QString filename);

};

#endif // ShaderMODEL_H
