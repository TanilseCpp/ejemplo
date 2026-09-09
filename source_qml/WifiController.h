#pragma once

#include <QObject>
#include <QStringList>
#include <socio-visual/QuickWidgets/WifiWindow/source_cpp/WiFiService.h>

class WifiController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList networks
               READ networks
               NOTIFY networksChanged)

    Q_PROPERTY(bool radioEnabled
               READ radioEnabled
               NOTIFY radioEnabledChanged)

    Q_PROPERTY(QString connectionState
               READ connectionState
               NOTIFY connectionStateChanged)

    Q_PROPERTY(bool internetAvailable
               READ internetAvailable
               NOTIFY internetAvailableChanged)

    Q_PROPERTY(QString overallState
               READ overallState
               NOTIFY overallStateChanged)

public:
    explicit WifiController(WiFiService& service, QObject* parent = nullptr)
        : QObject(parent)
        , m_service(service)
    {
    }

    QStringList networks() const
    {
        return m_networks;
    }

    bool radioEnabled() const
    {
        return m_radioEnabled;
    }

    QString connectionState() const
    {
        return m_connectionState;
    }

    bool internetAvailable() const
    {
        return m_internetAvailable;
    }

    QString overallState() const
    {
        return m_overallState;
    }

    Q_INVOKABLE void scanNetworks()
    {
        // Llamar a WifiService
        m_networks = {"WiFi_Home", "Office", "Guest"};

    }

    Q_INVOKABLE void connectToNetwork(
        const QString& ssid,
        const QString& password)
    {
        // Llamar a WifiService

        m_connectionState = "Connecting";

        // Cuando el backend confirme:
        m_connectionState = "Connected";
        m_internetAvailable = true;
        m_overallState = "Ready";

    }

    Q_INVOKABLE void disconnect()
    {
        // Llamar a WifiService

        // Cuando el backend confirme la desconexión
        m_connectionState = "Disconnected";
        m_internetAvailable = false;
        m_overallState = "Disconnected";
    }


private:
    QStringList m_networks;

    QString m_connectionState = "Disconnected";
    QString m_overallState = "Disconnected";

    bool m_radioEnabled = true;
    bool m_internetAvailable = false;

    WiFiService& m_service;
    
};