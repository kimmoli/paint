#ifndef RECURSIVESEARCH_H
#define RECURSIVESEARCH_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QVariantList>
#include <QDir>
#include <QStandardPaths>
#include <QMimeDatabase>
#include <QMimeType>
#include <QImageReader>
#include <QDateTime>

class RecursiveSearch : public QObject
{
    Q_OBJECT
public:
    explicit RecursiveSearch(const QStringList &locations, const QStringList &filters, bool sortName = false, QObject *parent = 0);

private:
    void recursiveSearch(const QString &folder);

    QStringList _locations;
    QStringList _filters;
    bool _sortName;

    bool _active;

signals:
    void haveFileData(const QVariantMap &data);
    void haveFolderData(const QVariantList &data);
    void completed();

public slots:
    void startSearch();
    void stopSearch();
};

#endif // RECURSIVESEARCH_H
