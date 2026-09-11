#pragma once

#include "interfaces/IWiFiManager.h"

class MockWiFiManager : public IWiFiManager
{
public:

    std::vector<WifiNetwork> scan() override
    {
        return {
            {"PrismaWiFi", 95, true},
            {"Office", 70, true},
            {"Guest", 30, false}
        };
    }

    bool connect(
        const std::string&,
        const std::string&) override
    {
        return true;
    }

    bool disconnect(const std::string&) override
    {
        return true;
    }

    WifiConnectionState getRadioState() const override
    {
        return WifiConnectionState::Connected;
    }

    WifiConnectionState getConnectionState() const override
    {
        return WifiConnectionState::Connected;
    }

    WifiConnectionState getInternetState() const override
    {
        return WifiConnectionState::Connected;
    }
};