#pragma once

#include "interfaces/IWiFiManager.h"
#include <memory>
#include <vector>

/**
 * @brief Service class for managing WiFi connections.
 *
 * This class provides an interface to scan for available WiFi networks,
 * connect to a network, disconnect from a network, and query the current
 * state of the WiFi radio, connection, and internet availability.
 * 
 * It will behaves as state machine, managing transitions between different WiFi states.
 */
class WiFiService
{
public:
    explicit WiFiService(
        std::unique_ptr<IWiFiManager> manager);

    std::vector<WifiNetwork> scanNetworks();

    bool connect(
        const std::string& ssid,
        const std::string& password);

    bool disconnect(const std::string& ssid);

    WifiConnectionState getRadioState() const;

    WifiConnectionState getConnectionState() const;

    WifiConnectionState getInternetState() const;

private:
    std::unique_ptr<IWiFiManager> m_manager;
};