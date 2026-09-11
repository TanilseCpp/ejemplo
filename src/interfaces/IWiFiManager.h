#pragma once

#include <string>
#include <vector>

struct WifiNetwork
{
    std::string ssid;
    int signalStrength;
    bool secured;
};

enum class WifiConnectionState
{
    Disconnected,
    Connecting,
    Connected,
    Failed
};

class IWiFiManager
{
public:
    virtual ~IWiFiManager() = default;

    virtual std::vector<WifiNetwork> scan() = 0;

    virtual bool connect(
        const std::string& ssid,
        const std::string& password) = 0;

    virtual bool disconnect(const std::string& ssid) = 0;

    virtual WifiConnectionState getRadioState() const = 0;

    virtual WifiConnectionState getConnectionState() const = 0;

    virtual WifiConnectionState getInternetState() const = 0;
};