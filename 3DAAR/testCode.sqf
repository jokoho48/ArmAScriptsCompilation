["localhost", 6379, "12345"] call db_fnc_setup;
call compile preprocessFileLineNumbers "fn_record.sqf";
call compile preprocessFileLineNumbers "fn_play.sqf"
