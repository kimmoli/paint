#ifndef FILEMODEL_H
#define FILEMODEL_H

#include <QObject>
#include <QAbstractListModel>

#include <QVector>
#include <QVariantMap>
#include <QVariantList>

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QFileInfoList>

#include <QThread>

class Filemodel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList filter READ getFilter WRITE setFilter FINAL)
    Q_PROPERTY(QString path READ getPath WRITE processPath FINAL)
    Q_PROPERTY(bool sorting READ getSorting WRITE setSorting)
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum FileRoles {
        NameRole = Qt::UserRole + 1,
        BaseRole,
        PathRole,
        SizeRole,
        TimestampRole,
        ExtensionRole,
        MimeRole,
        DirRole,
        ImageWidthRole,
        ImageHeightRole
    };
    explicit Filemodel(QObject *parent = 0);
    virtual ~Filemodel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual QHash<int, QByteArray> roleNames() const { return _roles; }

private:
    QHash<int, QByteArray> _roles;
    QVector<QVariantMap> _modelData;

    int count();

    QStringList _filter;
    QStringList& getFilter();
    void setFilter(const QStringList &filter);

    QString _path;
    QString& getPath();
    void setPath(const QString &path);

    bool _sorting;
    bool getSorting();
    void setSorting(bool newSorting);

public slots:
    void showRecursive(const QStringList &dirs);
    void processPath(const QString &path);
    void clear();
    bool remove(int index);
    QVariantMap get(int index);

private slots:
    void folderDataReceived(const QVariantList &data);

signals:
    void countChanged();
    void stopSearch();

};

#endif // FILEMODEL_H
