#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

if (isServer) then {
    GVAR(headlessClients) = [];
    GVAR(inRebalance) = false;
    ["ACE_HeadlessClientJoined", FUNC(handleConnectHC)] call ACEFUNC(common,addEventHandler);
};

ADDON = true;
