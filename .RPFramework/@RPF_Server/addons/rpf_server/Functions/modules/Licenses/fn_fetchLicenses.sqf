/*
Author: Kerkkoh
First Edit: 1.4.2017
*/
params["_player"];

_licenses = [(format["playerLicenses:%1", getPlayerUID _player]), 2] call ExternalS_fnc_ExtDBasync;

if ((count _licenses) <= 0) then {
	[0, (format["insertLicense:%1:%2:%3", "ID", (format[((configFile >> "RPF_licensesServerModule" >> "defaultIdCard") call BIS_fnc_getCfgData), name _player]), getPlayerUID _player])] call ExternalS_fnc_ExtDBquery;
	_licenses = [(format["playerLicenses:%1", getPlayerUID _player]), 2] call ExternalS_fnc_ExtDBasync;
};

_player setVariable ["licenses", _licenses, true];
