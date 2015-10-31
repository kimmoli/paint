#include <sailfishapp.h>
#include <QDir>
#include <QFile>
#include <QTextStreamFunction>
#include <QQmlEngine>
#include "ShaderModel.h"

ShaderModel::ShaderModel(QObject *parent)
    : QAbstractListModel(parent)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    QDir shaderDir = SailfishApp::pathTo("qml/glsl").toString(QUrl::RemoveScheme);
    QStringList fragmentShaders = shaderDir.entryList(QStringList() << "*.frag");
    fragmentShaders.sort();

    /* All fragmentshaders are added to model. Vertexshader only if file with same name exists. */
    while (fragmentShaders.count() > 0)
    {
        QString fs = fragmentShaders.first();

        /* Read fragment shader, and if exists, matching vertex shader */
        QString sFragmentShader = readFile(shaderDir.absolutePath() + QDir::separator() + fs);
        QString sVertexShader = readFile(shaderDir.absolutePath() +  QDir::separator() + fs.split(".").at(0) + ".vert");

        /* First row comment is used as name of the shader */
        QString name = sFragmentShader.split(QRegExp("[\r\n]"), QString::SkipEmptyParts).at(0);
        name.remove(0, 3);

        /* 2nd row comment are adjustable parameters, name;min;max separated with semicolon */
        QString par = sFragmentShader.split(QRegExp("[\r\n]"), QString::SkipEmptyParts).at(1);

        ShaderItem *shader = new ShaderItem();
        QQmlEngine::setObjectOwnership(shader, QQmlEngine::CppOwnership);

        shader->setName(name);
        shader->setFragmentShader(sFragmentShader);
        shader->setVertexShader(sVertexShader);

        ShaderParameterModel *parameters = new ShaderParameterModel();
        QQmlEngine::setObjectOwnership(parameters, QQmlEngine::CppOwnership);

        int i = 0;
        if (par.startsWith("// "))
        {
            par.remove(0, 3);
            QStringList pars = par.split(";");
            for (; i < pars.count(); i=i+3)
            {
                parameters->append(pars.at(i), pars.at(i+1).toDouble(), pars.at(i+2).toDouble());
            }
        }

        shader->addParameters(parameters);

        _shaders.append(shader);

        fragmentShaders.removeAt(0);
    }

    endInsertRows();

    emit countChanged();
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

int ShaderModel::count() const
{
    return _shaders.count();
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

    ShaderItem *shader = _shaders.at(index.row());

    switch (role)
    {
    case ObjectRole:
        return QVariant::fromValue<ShaderItem *>(shader);
        break;
    case NameRole:
        return shader->name();
        break;
    case FragmentShaderRole:
        return shader->fragmentShader();
        break;
    case VertexShaderRole:
        return shader->vertexShader();
        break;
    case ParametersRole:
        return shader->parameters();
        break;

    default:
        return QVariant();
        break;
    }
}

QHash<int, QByteArray> ShaderModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[ObjectRole] =         "object";
    roles[NameRole] =           "name";
    roles[FragmentShaderRole] = "fragmentShader";
    roles[VertexShaderRole] =   "vertexShader";
    roles[ParametersRole] =     "parameters";

    return roles;
}

QVariant ShaderModel::get(const quint32 &shaderId) const
{
    if (shaderId > (quint32)_shaders.count())
        return QVariant();

    ShaderItem *shader = _shaders.at(shaderId);
    QQmlEngine::setObjectOwnership(shader, QQmlEngine::CppOwnership);

    return QVariant::fromValue<ShaderItem *>(shader);
}
