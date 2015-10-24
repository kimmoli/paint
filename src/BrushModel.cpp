#include <sailfishapp.h>
#include "BrushModel.h"
#include <QDir>

Brush::Brush(const QString &name, const QString &path)
    : _name(name), _path(path)
{
}

QString Brush::name() const
{
    return _name;
}
QString Brush::path() const
{
    return _path;
}

BrushModel::BrushModel(QObject *parent)
    : QAbstractListModel(parent)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    QDir brushDir = SailfishApp::pathTo("qml/brush").toString(QUrl::RemoveScheme);
    QStringList brushes = brushDir.entryList(QStringList() << "*.png");
    brushes.sort();

    foreach (QString brush, brushes)
    {
        QString path = brushDir.absolutePath() + QDir::separator() + brush;
        brush.chop(4);

        _brushes << Brush(brush, path);
    }

    endInsertRows();
}

int BrushModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return _brushes.count();
}

QVariant BrushModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= _brushes.count())
        return QVariant();

    const Brush &brush = _brushes[index.row()];

    if (role == NameRole)
        return brush.name();
    if (role == PathRole)
        return brush.path();

    return QVariant();
}

QHash<int, QByteArray> BrushModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[NameRole] = "name";
    roles[PathRole] = "path";

    return roles;
}

QString BrushModel::getName(quint32 brushId) const
{
    return QString(_brushes.at(brushId).name());
}
