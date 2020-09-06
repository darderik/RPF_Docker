/*
Author: Kerkkoh
First Edit: 29.12.2016

Task format: [id, "Name", "Description", position, [assignedunits]]
*/

params ["_action", "_id", "_name", "_desc", "_pos"];

if (_action == 0) then {
	RPF_iDNumbers set [2, (RPF_iDNumbers select 2) + 1];
	RPF_dispatchTasks pushBack [(RPF_iDNumbers select 2), _name, _desc, _pos, []];
	if (!isNil {RPF_dispatcher}) then {
		(RPF_dispatchTasks select ((count RPF_dispatchTasks) - 1)) remoteExec ["ClientModules_fnc_policePlusDreceiveNewTask", RPF_dispatcher];
	};
} else {
	_i = 0;
	{
		if ((_x select 0) == _id) exitWith {
			_i = _forEachIndex;
		};
	}forEach RPF_dispatchTasks;
	RPF_dispatchTasks deleteAt _i;
};
if (!isNil {RPF_dispatcher}) then {
	[RPF_dispatchTasks] remoteExec ["ClientModules_fnc_policePlusDrefreshTasks", RPF_dispatcher];
};
