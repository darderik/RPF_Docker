/*
Author: Kerkkoh
First Edit: 5.12.2016
*/

params ["_player"];

_posCell = 0;
_counter = 0;
_posPlayer = 0;
{
	_y = _x;
	_counter = _forEachIndex;
	{
		if (_x == _player) then {
			_posPlayer = _forEachIndex;
			_posCell = _counter;
		};
	}forEach (_y select 0);
}forEach RPF_JailCells;

(RPF_JailCells select _posCell) set [2, true];

((RPF_JailCells select _posCell) select 0) deleteAt _posPlayer;

_player setVariable ["jailed", false, true];

_player setPos ((configFile >> "RPF_jailServerModule" >> "jailReleaseLocation") call BIS_fnc_getCfgData);
