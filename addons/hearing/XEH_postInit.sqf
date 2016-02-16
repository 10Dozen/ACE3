#include "script_component.hpp"

if (!hasInterface) exitWith {};

GVAR(cacheAmmoLoudness) = createLocation ["ACE_HashLocation", [-10000,-10000,-10000], 0, 0];
GVAR(cacheAmmoLoudness) setText QGVAR(cacheAmmoLoudness);

GVAR(deafnessDV) = 0;
GVAR(deafnessPrior) = 0;
GVAR(volume) = 1;
GVAR(playerVehAttenuation) = 1;
GVAR(time3) = 0;

["SettingsInitialized", {
    TRACE_1("settingInit",GVAR(EnableCombatDeafness));
    // Only run if combat deafness is enabled
    if (!GVAR(EnableCombatDeafness)) exitWith {};

    // Spawn volume updating process
    [FUNC(updateVolume), 1, [false]] call CBA_fnc_addPerFrameHandler;
}] call EFUNC(common,addEventHandler);

//Update veh attunation when player veh changes
["playerVehicleChanged", {_this call FUNC(updatePlayerVehAttenuation);}] call EFUNC(common,addEventHandler);
["playerTurretChanged", {_this call FUNC(updatePlayerVehAttenuation);}] call EFUNC(common,addEventHandler);

//Reset deafness on respawn (or remote control player switch)
["playerChanged", {
    GVAR(deafnessDV) = 0;
    GVAR(deafnessPrior) = 0;
    ACE_player setVariable [QGVAR(deaf), false];
    GVAR(time3) = 0;
}] call EFUNC(common,addEventhandler);
