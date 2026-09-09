#include "WiFiService.h"

WiFiService::WiFiService(
    std::unique_ptr<IWiFiManager> manager)
    : m_manager(std::move(manager))
{
}

std::vector<WifiNetwork> WiFiService::scanNetworks()
{
    return m_manager->scan();
}

bool WiFiService::connect(
    const std::string& ssid,
    const std::string& password)
{
    if (m_manager->getRadioState() != WifiConnectionState::Connected)
        return false;

    if (ssid.empty())
        return false;

    if (password.empty())
        return false;
        
    return m_manager->connect(ssid, password);
}

bool WiFiService::disconnect(const std::string& ssid)
{
    return m_manager->disconnect(ssid);
}

WifiConnectionState WiFiService::getRadioState() const
{
    return m_manager->getRadioState();
}

WifiConnectionState WiFiService::getConnectionState() const
{
    return m_manager->getConnectionState();
}

WifiConnectionState WiFiService::getInternetState() const
{
    return m_manager->getInternetState();
}