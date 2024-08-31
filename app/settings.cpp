#include "settings.h"

Settings::Settings()
{
    // If the variable `XDG_CONFIG_HOME` is set, use that
    // If not, use `HOME`
    // If this one is empty too, use getpwuid 
    QString configDir = QString::fromUtf8(getenv("XDG_CONFIG_HOME"));
    if (configDir.isEmpty()) {
        configDir = QString::fromUtf8(getenv("HOME"));
        if (configDir.isEmpty()) {
            configDir = QString::fromUtf8(getpwuid(getuid())->pw_dir);
        }
        configDir.append("/.config");
    }
    configDir.append("/cool-retro-term/");
    path = new QString(configDir);
}

Q_INVOKABLE void Settings::initialize() {
    QDir().mkpath(*path);
    QDir().mkpath(*path + "profiles");

    QStringList files = {"custom_profiles.json", "settings.json", "profile.json"};
    for (const auto& file : files) {
        QFile f(*path + file);
        if (!f.exists()) {
            f.open(QIODevice::WriteOnly);
            f.close();
        }
    }

    initialized = true;
}

Q_INVOKABLE bool Settings::setSetting(const QString& fileName, const QString& value) {
    if(!initialized)initialize();
    QFile f(*path + fileName + ".json");
    if (f.open(QIODevice::WriteOnly)) {
        bool res = f.write(value.toStdString().c_str());
        f.close();
        return res;
    }
    return false;
}

Q_INVOKABLE QString Settings::getSetting(const QString& setting) {
    if(!initialized)initialize();
    QFile f(*path + setting + ".json");
    if (f.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString fileContent = f.readAll();
        f.close();
        return fileContent;
    }
    return QString();
}

Q_INVOKABLE QString Settings::getProfiles() {
    if(!initialized)initialize();
    // Get profiles from the `custom_profiles.json` file
    QString fileContent = getSetting("custom_profiles");
    QJsonDocument jsonDoc = QJsonDocument::fromJson(fileContent.toUtf8());
    QJsonArray a = jsonDoc.array();

    // Add the profiles from the `profiles` directory
    QDirIterator it(*path + "profiles", QStringList() << "*.json", QDir::Files);
    while (it.hasNext()) {
	QFileInfo fileInfo(it.next());
    	QString fileContent2 = getSetting("profiles/" + fileInfo.baseName());
    	QJsonDocument fDoc = QJsonDocument::fromJson(fileContent2.toUtf8());
	QJsonObject obj = fDoc.object();
	obj["builtin"] = true; // Make them appear as builtin, so they can't be modified in the app
	a.append(obj);
    }

    return QJsonDocument(a).toJson();
}
