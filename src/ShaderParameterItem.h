#ifndef SHADERPARAMETERITEM_H
#define SHADERPARAMETERITEM_H

#include <QObject>

class ShaderParameterItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(double min READ min NOTIFY minChanged)
    Q_PROPERTY(double max READ max NOTIFY maxChanged)
    Q_PROPERTY(double step READ step NOTIFY stepChanged)
    Q_PROPERTY(double now READ now WRITE setNow NOTIFY nowChanged)

public:
    explicit ShaderParameterItem(QObject *parent = 0);

    QString name() const;
    double min() const;
    double max() const;
    double step() const;
    double now() const;

    void setName(const QString &n);
    void setMin(const double &v);
    void setMax(const double &v);
    void setStep(const double &v);
    void setNow(const double &v);

signals:
    void nameChanged();
    void minChanged();
    void maxChanged();
    void stepChanged();
    void nowChanged();

private:
    QString _name;
    double _min;
    double _max;
    double _step;
    double _now;
};

Q_DECLARE_METATYPE(ShaderParameterItem *)

#endif // SHADERPARAMETERITEM_H
