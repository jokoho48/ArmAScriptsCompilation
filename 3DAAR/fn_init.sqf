if (isNil "JK_3DAAR_Enabled") then {
    JK_3DAAR_Enabled = true;
};
if (isNil "JK_AARisDebug") then {
    JK_AARisDebug = true;
};
JK_Hash = "";
for "_i" from 1 to 5 do {
    JK_Hash = JK_Hash + str(floor(random 100));
};
JK_lastLoopisDone = true;
JK_fnc_mainLoop = {
    private ["_key", "_data", "_scriptHandle", "_scriptHandleKeys", "_oldKeys"];
    JK_lastLoopisDone = false;
    JK_Array = [];
    {
        private ["_tempArray"];
        _tempArray = [];
        {
            if (isPlayer _x ||JK_AARisDebug) then {
                private ["_name", "_pos", "_dir", "_health", "_side"];
                _name = name _x;
                _pos = getPos _x;
                _dir = getDir _x;
                _health = damage _x;
                _side = side _x;
                _tempArray pushBack [_name, _pos, _dir, _health, _side];
            };
        } forEach units _x;
        JK_Array pushBack _tempArray;
    } forEach allGroups;
    _key = "";
    {
        _key = _key + str _x;
        false
    } count (false call db_fnc_time);
    _key = _key + JK_Hash;
    _oldKeys = (JK_Hash + "JK_oldKeys") call db_fnc_load;
    _oldKeys pushBack _key;
    _scriptHandleKeys = [(JK_Hash + "JK_oldKeys"), _oldKeys, 2] spawn db_fnc_save;
    _data = [time, JK_Array];
    _scriptHandle = [_key, str _data, 1] spawn db_fnc_save;

    waitUntil {scriptDone _scriptHandle};
    waitUntil {scriptDone _scriptHandleKeys};
    sleep 10;
    JK_lastLoopisDone = true;
};

if (JK_3DAAR_Enabled) then {
    [{
        if !(JK_lastLoopisDone) exitWith {};
        [] spawn JK_fnc_mainLoop;
    }, 0, []] call CBA_fnc_addPerFrameHandler;
};

JK_fnc_deleteOld = {
    {
        [_x, 2] call db_fnc_delete
    } count ((JK_Hash + "JK_oldKeys") call db_fnc_load);
};
