#include <sailfishapp.h>
#include <QDir>
#include <QFile>
#include <QTextStreamFunction>
#include "ShaderModel.h"
#include <QDebug>

Shader::Shader(const QString &name, const QString &fragment, const QString &vertex, const QVariantList &params)
    : _name(name), _fragment(fragment), _vertex(vertex), _params(params)
{
}

QString Shader::name() const
{
    return _name;
}
QString Shader::fragment() const
{
    return _fragment;
}
QString Shader::vertex() const
{
    return _vertex;
}

QVariantList Shader::params() const
{
    return _params;
}

ShaderModel::ShaderModel(QObject *parent)
    : QAbstractListModel(parent)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    QDir shaderDir = SailfishApp::pathTo("qml/glsl").toString(QUrl::RemoveScheme);
    QStringList fragmentShaders = shaderDir.entryList(QStringList() << "*.frag" << "*.fsh");
    fragmentShaders.sort();

    QStringList vsExtensions(QStringList() << "*.vert" << "*.vsh");
    QStringList vertexShaders = shaderDir.entryList(vsExtensions);
    vertexShaders.sort();

    /* All fragmentshaders are added to model. Vertexshader only if file with same name exists. */
    while (fragmentShaders.count() > 0)
    {
        QString fs = fragmentShaders.first();
        QString name = fs.split(".").at(0);

        QString fragmentShader = readFile(shaderDir.absolutePath() + QDir::separator() + fs);
        QString vertexShader;

        foreach (QString extension, vsExtensions)
        {
            QString vsName = name + "." + extension.split(".").at(1);

            if (vertexShaders.contains(vsName))
                vertexShader = readFile(shaderDir.absolutePath() + QDir::separator() + vsName);
        }

        /* First row comment is used as name of the shader */
        name = fragmentShader.split(QRegExp("[\r\n]"), QString::SkipEmptyParts).at(0);
        name.remove(0, 3);

        /* 2nd row comment are adjustable parameters, name;min;max separated with semicolon */
        QString par = fragmentShader.split(QRegExp("[\r\n]"), QString::SkipEmptyParts).at(1);
        QVariantList params;

        int i = 0;
        if (par.startsWith("// "))
        {
            par.remove(0, 3);
            QStringList pars = par.split(";");
            for (; i < pars.count(); i=i+3)
            {
                params << pars.at(i);
                params << pars.at(i+1).toFloat();
                params << pars.at(i+2).toFloat();
                params << (pars.at(i+1).toFloat() + pars.at(i+2).toFloat())/2.0; // mid value
            }
        }
        for (; i < 9; i=i+3)
        {
            params << "";
            params << 0.0;
            params << 1.0;
            params << 0.0;
        }

        qDebug() << params;

        _shaders << Shader(name, fragmentShader, vertexShader, params);

        fragmentShaders.removeAt(0);
    }

    endInsertRows();
}

QString ShaderModel::readFile(QString filename)
{
    QFile f(filename);

    if (!f.open(QFile::ReadOnly | QFile::Text))
        return QString();

    QTextStream s(&f);
    QString ret = s.readAll();

    f.close();

    return ret;
}

int ShaderModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return _shaders.count();
}

QVariant ShaderModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= _shaders.count())
        return QVariant();

    const Shader &shader = _shaders[index.row()];

    if (role == NameRole)
        return shader.name();
    if (role == FragmentRole)
        return shader.fragment();
    if (role == VertexRole)
        return shader.vertex();
    if (role == ParamsRole)
        return shader.params();

    return QVariant();
}

QHash<int, QByteArray> ShaderModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[NameRole] = "name";
    roles[FragmentRole] = "fragmentShader";
    roles[VertexRole] = "vertexShader";
    roles[ParamsRole] = "parameters";

    return roles;
}

QString ShaderModel::getName(quint32 shaderId) const
{
    return QString(_shaders.at(shaderId).name());
}

QString ShaderModel::getFragmentShader(quint32 shaderId) const
{
    return QString(_shaders.at(shaderId).fragment());
}

QString ShaderModel::getVertexShader(quint32 shaderId) const
{
    return QString(_shaders.at(shaderId).vertex());
}

QVariantList ShaderModel::getParameters(quint32 shaderId) const
{
    return QVariantList(_shaders.at(shaderId).params());
}
