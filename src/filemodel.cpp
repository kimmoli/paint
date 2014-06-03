#include "filemodel.h"
#include "recursivesearch.h"

#include <QDateTime>
#include <QDebug>

#include <QMimeDatabase>
#include <QMimeType>
#include <QImageReader>

#include <QStandardPaths>

#include <QTimer>

#include <QDebug>

Filemodel::Filemodel(QObject *parent) :
    QAbstractListModel(parent)
{
    _roles[NameRole] = "name";
    _roles[BaseRole] = "base";
    _roles[PathRole] = "path";
    _roles[SizeRole] = "size";
    _roles[TimestampRole] = "time";
    _roles[ExtensionRole] = "ext";
    _roles[MimeRole] = "mime";
    _roles[DirRole] = "dir";
    _roles[ImageWidthRole] = "width";
    _roles[ImageHeightRole] = "height";
    _sorting = true;
    _path = QDir::homePath();
    _filter = QStringList() << "*.*";
}

Filemodel::~Filemodel()
{
    _modelData.clear();
}

int Filemodel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return _modelData.count();
}

QVariant Filemodel::data(const QModelIndex &index, int role) const
{
    //qDebug() << "get" << QString::number(index.row()) << _roles[role];
    int row = index.row();
    if (row < 0 || row >= _modelData.size())
        return QVariant();
    //return _modelData.at(index.row()).value(_roles.value(role));
    return _modelData[index.row()][_roles[role]];
}

QStringList &Filemodel::getFilter()
{
    return _filter;
}

QString &Filemodel::getPath()
{
    return _path;
}

void Filemodel::setFilter(const QStringList &filter)
{
    //qDebug() << "set filter:" << filter;
    _filter = filter;
}

bool Filemodel::getSorting()
{
    return _sorting;
}

void Filemodel::setSorting(bool newSorting)
{
    _sorting = newSorting;
}

void Filemodel::showRecursive(const QStringList &dirs)
{
    Q_EMIT stopSearch();

    clear();

    RecursiveSearch *recursive = new RecursiveSearch(dirs, _filter, !_sorting);
    QObject::connect(this, SIGNAL(stopSearch()), recursive, SLOT(stopSearch()));
    QObject::connect(recursive, SIGNAL(haveFolderData(QVariantList)), this, SLOT(folderDataReceived(QVariantList)));
    QThread *thread = new QThread(recursive);
    recursive->moveToThread(thread);
    QObject::connect(thread, SIGNAL(started()), recursive, SLOT(startSearch()));
    thread->start();
}

void Filemodel::processPath(const QString &path)
{
    _path = path;
    if (_path == "home")
        _path = QDir::homePath();
    clear();

    //qDebug() << "Processing" << path << _filter;
    QDir dir(path);
    const QFileInfoList &list = dir.entryInfoList(_filter, QDir::AllDirs | QDir::NoDot | QDir::NoSymLinks | QDir::Files, (_sorting ? QDir::Time : QDir::Name) | QDir::DirsFirst);
    foreach (const QFileInfo &info, list) {
        //qDebug() << "adding" << info.absoluteFilePath();
        if (dir.isRoot() && info.fileName() == "..")
            continue;
        QVariantMap fileInfo;

        beginInsertRows(QModelIndex(), _modelData.size(), _modelData.size() + list.size());
        fileInfo["name"] = info.fileName();
        fileInfo["base"] = info.baseName();
        fileInfo["path"] = info.absoluteFilePath();
        fileInfo["size"] = info.size();
        fileInfo["time"] = info.created().toTime_t();
        fileInfo["ext"] = info.suffix();
        fileInfo["dir"] = info.isDir();

        QMimeDatabase db;
        QMimeType type = db.mimeTypeForFile(info.absoluteFilePath());
        fileInfo["mime"] = type.name();

        QImageReader reader(info.absoluteFilePath());
        if (reader.canRead()) {
            fileInfo["width"] = reader.size().width();
            fileInfo["height"] = reader.size().height();
        }
        else {
            fileInfo["width"] = 0;
            fileInfo["height"] = 0;
        }

        _modelData.append(fileInfo);
        endInsertRows();
        Q_EMIT countChanged();
    }
}

void Filemodel::clear()
{
    beginResetModel();
    _modelData.clear();
    endResetModel();
}

int Filemodel::count()
{
    return _modelData.size();
}

bool Filemodel::remove(int index)
{
    if (index > -1 && index < _modelData.size()) {
        QFile file(_modelData[index]["path"].toString());
        if (file.exists()) {
            beginRemoveRows(QModelIndex(), index, index);
            _modelData.remove(index);
            endRemoveRows();
            Q_EMIT countChanged();
            return file.remove();
        }
        else
            return false;
    }
    else
        return false;
}

QVariantMap Filemodel::get(int index)
{
    if (index > -1 && index < _modelData.size())
        return _modelData[index];
    return QVariantMap();
}

void Filemodel::folderDataReceived(const QVariantList &data)
{
    beginInsertRows(QModelIndex(), _modelData.size(), _modelData.size() + data.size() - 1);

    foreach (const QVariant &fileData, data) {
        _modelData.append(fileData.toMap());
    }

    endInsertRows();

    Q_EMIT countChanged();
}
