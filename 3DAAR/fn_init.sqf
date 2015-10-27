if (isNil "JK_3DAAR_Enabled") then {
    JK_3DAAR_Enabled = true;
};
if (isNil "JK_AARisDebug") then {
    JK_AARisDebug = true;
};
JK_Hash = "";
for "_i" from 10 to 0 do {
    JK_Hash = JK_Hash + str(random 100000);
};
JK_lastLoopisDone = true;
JK_fnc_mainLoop = {
    private ["_key", "_data"];
    JK_lastLoopisDone = false;
    JK_Array = [];
    {
        private ["_tempArray"];
        _tempArray = [];
        {
            if (isPlayer _x ||JK_AARisDebug) then {
                private ["_name", "_pos", "_dir", "_health"];
                _name = name _x;
                _pos = getPos _x;
                _dir = getDir _x;
                _health = damage _x;
                _tempArray pushBack [_name, _pos, _dir, _health];
            };
        } forEach units _x;
        JK_Array pushBack _tempArray;
    } forEach allGroups;
    _key = "";
    {
        _key = _key + str _x;
        false
    } count (false call db_fnc_time);
    _key = _key + JK_Hash
    _data = [time, JK_Array];
    [_key, str _data, 1] spawn db_fnc_save;
    JK_lastLoopisDone = true;
};

if (JK_3DAAR_Enabled) then {
    [{
        if (JK_lastLoopisDone) exitWith {};
        [] spawn JK_fnc_mainLoop;
    }, 0, []] call CBA_fnc_addPerFrameHandler;
};
