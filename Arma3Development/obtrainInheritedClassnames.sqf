
{
    private _classname = configName _x;
    private _parent = configName (inheritsFrom (configFile >> 'CfgMagazines' >> _classname));
    if (_parent == "OM_Magazine") then {
        diag_log formatText ["class %1 : OM_Magazine {\n    scope = 2;\n};\n\n", _classname];
        {
            private _subclass = configName _x;
            private _subclassParent = configName (inheritsFrom (configFile >> 'CfgMagazines' >> _subclass));
            if (_classname == _subclassParent) then {
                diag_log formatText ["class %1 : %2 {\n    scope = 2;\n};\n\n", _subclass, _subclassParent];
            };
        } forEach ("true" configClasses (configFile >> "CfgMagazines"));
    };
} forEach ("true" configClasses (configFile >> "CfgMagazines"));
