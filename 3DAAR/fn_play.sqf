JK_currentPos = [0,0,0];
JK_currentIndex = 0;
JK_Hash = "6330512051JK_oldKeys";
JK_allKeys = JK_Hash call db_fnc_load;
JK_currentKey = JK_allKeys select 0;
JK_currentArray = [JK_currentKey, 0] call db_fnc_load;
JK_currentTime = time;
JK_fnc_Lerp = {
    params ["_start", "_target", "_amout"];
    _start + (_target - _start) * _amount;
};

JK_fnc_VectorLerp = {
    params ["_startPos", "_targetPos", "_amount"];
    private _ret = [];
    {
        _ret pushBack [_x, _targetPos select _forEachIndex, _amount] call JK_fnc_Lerp;
        nil
    } count _startPos;
    _ret
};

JK_fnc_updateCurrent = {
    params [["_step", 1]];
    JK_currentIndex = ((JK_currentIndex + _step) min (count JK_allKeys - 1)) max 0;
    JK_currentKey = JK_allKeys select JK_currentIndex;
    JK_currentArray = [JK_currentKey, 0] call db_fnc_load;
};
addMissionEventHandler ["Draw3D", {
    private _deltaTime = time - JK_currentTime;
    JK_currentTime = time;
    private _nextFrame = false;
    {
        {
            _x params ["_name", "_pos", "_dir", "_health", "_side", "_currentPos"];
            _color = [[0,0,0], [1,1,1], _health] call JK_fnc_VectorLerp;
            _color set [3, 1];
            _icon = ["aaf_ca.paa", "CSAT_ca.paa", "Nato_ca.paa"] param[[independent, EAST, WEST] find _side, ""];
            if (_currentPos distance _pos >= 0.2) then {
                _nextFrame = true;
            } else {
                _nextFrame = false;
            };
            _currentPos = [_currentPos, _pos, _deltaTime*10] call JK_fnc_VectorLerp;
            _x set [5, _currentPos];
            drawIcon3D [_icon, _color, _currentPos, 1, 1, 0, _name, 1, 0.05];
            nil
        } count _x;
        nil
    } count (JK_currentArray select 1);
    if (_nextFrame) then {
        call JK_fnc_updateCurrent;
    };
}];


player addAction ["Skip 1 Key", {1 call JK_fnc_updateCurrent;}];
player addAction ["Back 1 Key", {-1 call JK_fnc_updateCurrent;}];

player addAction ["Skip 10 Key", {10 call JK_fnc_updateCurrent;}];
player addAction ["Back 10 Key", {-10 call JK_fnc_updateCurrent;}];
