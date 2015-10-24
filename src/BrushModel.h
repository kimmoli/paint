#ifndef BRUSHMODEL_H
#define BRUSHMODEL_H

#include <QAbstractListModel>
#include <QStringList>

class Brush
{
public:
    Brush(const QString &name, const QString &path);

    QString name() const;
    QString path() const;

private:
    QString _name;
    QString _path;
};

class BrushModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum BrushRoles
    {
        NameRole = Qt::UserRole+1,
        PathRole
    };

    BrushModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE QString getName(quint32 brushId) const;

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Brush> _brushes;

};

#endif // BRUSHMODEL_H
