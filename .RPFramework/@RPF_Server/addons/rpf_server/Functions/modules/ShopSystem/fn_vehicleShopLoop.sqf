/*
Author: Kerkkoh
First Edit: 24.4.2016

Array format
["classname", position, direction, price]

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
To make new buyable cars in the editor, put this in their init:

this setVariable ["carShop", PRICEHERE, true];

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

RPF_vehicleShopVehicles = [
	["C_SUV_01_F", [16741.5,12505.9,0.0241032], 322.976, 10000],
	["C_Offroad_01_F", [16735.7,12501.3,-0.00195217], 322.976, 10000],
	["C_Van_01_box_F", [16730,12497,0.0254688], 322.976, 15000]
];

{
	if ((_x getVariable ["carShop", -1]) > 0) then {
		RPF_vehicleShopVehicles pushBack [typeOf _x, getPos _x, getDir _x, (_x getVariable "carShop")];
		_x setVariable ["buyableThing", [typeOf _x, (_x getVariable "carShop"), 0], true];
		_x lock 2;
		_x allowDamage false;
		clearItemCargoGlobal _x;
	};
}forEach (entities [["LandVehicle","Air","Ship"],[], false, true]);

for "_i" from 0 to 1 step 0 do 
{
	{
		_class = _x select 0;
		_pos = _x select 1;
		_dir = _x select 2;
		_price = _x select 3;
		_nearest = nearestObjects [_pos, ["AllVehicles"], 3];
		if (count _nearest == 0) then {
			_veh = _class createVehicle _pos;
			_veh setDir _dir;
			_veh setVariable ["buyableThing", [_class, _price, 0], true];
			_veh lock 2;
			_veh allowDamage false;
			clearItemCargoGlobal _veh;
		};
	}forEach RPF_vehicleShopVehicles;
	sleep 300;
};