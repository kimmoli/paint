#include "recursivesearch.h"

#include <QDebug>

RecursiveSearch::RecursiveSearch(const QStringList &locations, const QStringList &filters, bool sortName, QObject *parent) :
    _active(false),
    QObject(parent)
{
    _locations = locations;
    _filters = filters;
    _sortName = sortName;
}

void RecursiveSearch::recursiveSearch(const QString &folder)
{
    QString mpath = folder;
    if (mpath == "home")
        mpath = QDir::homePath();
    else if (mpath == "image") {
        mpath = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    }
    else if (mpath == "music") {
        mpath = QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
    }
    else if (mpath == "video") {
        mpath = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
    }
    else if (mpath == "sdcard") {
        mpath = "/media/" + mpath;
    }
    else if (mpath == "avatars") {
        mpath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/avatar";
    }

    QVariantList folderData;

    //qDebug() << "Recursive search in:" << mpath << "filter:" << _filters;

    QDir dir(mpath);
    const QFileInfoList &list = dir.entryInfoList(_filters, QDir::Files | QDir::AllDirs | QDir::NoSymLinks | QDir::NoDot | QDir::NoDotDot, _sortName ? QDir::Name : QDir::Time);
    foreach (const QFileInfo &info, list) {
        if (!_active)
            break;
        if (info.isDir()) {
            recursiveSearch(info.filePath());
        }
        else if (info.isFile()) {
            //qDebug() << "adding" << info.filePath();
            QVariantMap fileData;

            fileData["name"] = info.fileName();
            fileData["base"] = info.baseName();
            fileData["path"] = info.filePath();
            fileData["size"] = info.size();
            fileData["time"] = info.created().toTime_t();
            fileData["ext"] = info.suffix();
            fileData["dir"] = false;

            QMimeDatabase db;
            QMimeType type = db.mimeTypeForFile(info.absoluteFilePath());
            fileData["mime"] = type.name();

            QImageReader reader(info.absoluteFilePath());
            if (reader.canRead()) {
                fileData["width"] = reader.size().width();
                fileData["height"] = reader.size().height();
            }
            else {
                fileData["width"] = 0;
                fileData["height"] = 0;
            }

            if (_active)
                Q_EMIT haveFileData(fileData);

            folderData.append(fileData);
        }
    }

    if (!folderData.isEmpty() && _active)
        Q_EMIT haveFolderData(folderData);
}

void RecursiveSearch::startSearch()
{
    _active = true;
    foreach (const QString &folder, _locations) {
        recursiveSearch(folder);
    }
    stopSearch();
}

void RecursiveSearch::stopSearch()
{
    qDebug() << "stopSearch";
    _active = false;
    QObject::disconnect(this, 0, 0, 0);
    Q_EMIT completed();
    this->deleteLater();
}

