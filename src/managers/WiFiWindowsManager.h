#pragma once
#include "interfaces/IWiFiManager.h"

/**
 * WifiWindowsManager is a concrete implementation of IWifiManager
 * for managing WiFi connections on Windows systems.
 */
class WifiWindowsManager : public IWiFiManager
{
public:

    std::vector<WifiNetwork> scan() override {}

    bool connect(
        const std::string& ssid,
        const std::string& password) override {}

    bool disconnect(const std::string& ssid) override {}

    WifiConnectionState getRadioState() const override {}

    WifiConnectionState getConnectionState() const override {}

    WifiConnectionState getInternetState() const override {}
};