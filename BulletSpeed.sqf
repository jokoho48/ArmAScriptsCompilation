JK_bullet = objNull;
addMissionEventHandler ["EachFrame", {
    private _vel = vectorMagnitude (velocity JK_bullet);
    hintSilent format ["%1 %2 m/s", typeOf JK_bullet, _vel];
}];

player addEventHandler ["FiredMan", {
    params ["", "", "", "", "_ammo", "", "_projectile"];
    if (isNull _projectile) then {
        _projectile = nearestObject [_shooter, _ammo];
        _this set [6, _projectile];
    };
    JK_bullet = _projectile;
}];
