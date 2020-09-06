/*
Author: Kerkkoh
First Edit: 18.7.2017
*/

params ["_player", "_key"];

_keys = [(format["keys:%1", getPlayerUID _player]), 2] call ExternalS_fnc_ExtDBasync;


_id = -1;
{
	if (_key isEqualTo (_this select 1)) then {
		_id = _this select 0;
	};
}forEach _keys;

if (_id isEqualTo -1) exitWith {diag_log "Server_fnc_deleteKey encountered an error with a non-existing key"};

_del = [0, (format["deleteKey:%1", _id])] call ExternalS_fnc_ExtDBquery;
