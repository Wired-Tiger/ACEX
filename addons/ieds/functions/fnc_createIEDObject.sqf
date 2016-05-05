
#include "script_component.hpp"

#define LAND_IEDS ["ACE_IEDLandBig_Range", "ACE_IEDLandSmall_Range"]
#define URBAN_IEDS ["ACE_IEDUrbanBig_Range", "ACE_IEDUrbanSmall_Range"]

params ["_logic"];

private ["_logic","_typeOfIED", "_sizeOfIED", "_heightOfIED", "_iedClass", "_iedCreated"];

if (isNull _logic) exitwith {};

private _typeOfIED = _logic getvariable ["typeOfIED", 0];
private _sizeOfIED = _logic getvariable ["sizeOfIED", 0];
private _heightOfIED = _logic getvariable ["heightOfIED", 0];

private _iedClass = switch (_typeOfIED) do {
    case 0: { LAND_IEDS select _sizeOfIED};
    case 1: { URBAN_IEDS select _sizeOfIED };
};
private _iedCreated = _iedClass createVehicle (getPos _logic);

if (_logic getvariable ["iedActivationType",0] == 0) then {
    createMine [_iedClass, getPos _logic, [], 0];
};

_logic setvariable [QGVAR(linkedIED), _iedCreated, true]; // TODO do we need a global flag here?
_iedCreated setvariable [QGVAR(linkedIED), _logic, true]; // TODO do we need a global flag here?

_iedCreated setPos [getPos _Logic select 0, getPos _Logic select 1, (getPos _Logic select 2) + _heightOfIED];

_iedCreated addEventHandler ["Killed", {
    params ["_ied", "_killer"];

    private _logic = _ied getvariable [QGVAR(linkedIED), objNull];
    private _activationType = _logic getvariable ["iedActivationType", 0];
    [_logic] call FUNC(onIEDActivated);

    if (_activationType == -1) then {
        private _iedClass = typeOf _ied;
        private _iedPos = getPos _ied;
        private _ammoClass = getText(configFile >> "CfgVehicles" >> _iedClass >> "ammo");
        private _dummyIed = _ammoClass createVehicle _iedPos;
        _dummyIed setPos _iedPos;
        _dummyIed setDamage 1;
    };
    deleteVehicle _ied;
}];

_iedCreated;
