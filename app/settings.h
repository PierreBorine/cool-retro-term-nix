#ifndef SETTINGS_H
#define SETTINGS_H

#include <QDirIterator>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <unistd.h>
#include <pwd.h>

class Settings : public QObject
{
    Q_OBJECT

private:
    QString *path;
    bool initialized = false;
public:
    Settings();
    Q_INVOKABLE void initialize();
    Q_INVOKABLE bool setSetting(const QString& fileName, const QString& value);
    Q_INVOKABLE QString getSetting(const QString& setting);
    Q_INVOKABLE QString getProfiles();
};

#endif // SETTINGS_H
