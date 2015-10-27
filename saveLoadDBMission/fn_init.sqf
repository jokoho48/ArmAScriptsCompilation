JK_fnc_saveMission = {
    private ["_unitData", "_markerData"];
    _unitData = [];
    {
        private ["_grpData", "_code", "_side"];
        _grpData = [];
        {
            if !(isPlayer _x && side _x == WEST) then {
                private ["_class", "_gear", "_pos", "_skill", "_rank", "_code"];
                _class =  typeOf _x;
                _gear = [_x] call ace_common_fnc_getAllGear;
                _gear pushBack [currentWeapon _x, currentMuzzle _x, currentWeaponMode _x];
                _pos = getPos _x;
                _skill = skill _x;
                _rank = rank _x;
                _code = _x getVariable ["JK_CodeExecution", {}];
                _grpData pushBack [_class, _gear, _pos, _rank, _code];
            };
            nil
        } count units _x;
        _side = side _x;
        _grpCode = _x getVariable ["JK_CodeExecution", {}];
        _unitData pushBack [_side, _grpData, _code];
        nil
    } count allGroups;
    _markerData = [];
};

_unitArray = "JK_unitArray" call db_fnc_load;
_markerArray = "JK_markerArray" call db_fnc_load;

{
    private "_grp";
    _x params ["_side", "_units", "_code"];
    _grp = createGroup _side;
    {
        private "_unit";
        _x params ["_class", "_gear", "_pos", "_skill", "_rank", "_code"];
        _unit = _class createUnit [ _pos, _grp, init, skill, rank];
        _unit
        [_unit, _gear] call ace_respawn_fnc_restoreGear;
        nil
    } count _x;
    nil
} count _unitArray;

{
    private "_mrk";
    _x params ["_markerName", "_markerPos", "_markerType", "_markerText", "_markerIcon", "_markerColor", "_markerDir", "_markerBrush", "_markerShape", "_markerAlpha", "_markerSize"];
    _mrk = createMarker [_markerName, _markerPos];
    _mrk setMarkerPos _markerPos;
    _mrk setMarkerType _markerType;
    _mrk setMarkerText _markerText;
    _mrk setMarkerDir _markerDir;
    _mrk setMarkerBrush _markerBrush;
    _mrk setMarkerColor _markerColor;
    _mrk setMarkerShape _markerShape;
    _mrk setMarkerSize _markerSize;
    _mrk setMarkerAlpha _markerAlpha;
    nil
} count _markerArray;

addMissionEventHandler ["End", JK_fnc_saveMission];
