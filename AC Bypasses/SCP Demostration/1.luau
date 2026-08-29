local oth = (oth or {hook = hookfunction}) :: typeof(oth);
do
    local replicated_storage = cloneref(game:GetService("ReplicatedStorage"));
    local detection_remote: RemoteEvent = replicated_storage.AC_CTS;
    
    local players: Players = cloneref(game:GetService("Players"));
    local player = players.LocalPlayer :: Player;

    for _: any, v: ConnectionProxy in (getconnections(detection_remote:GetPropertyChangedSignal("Parent"))) do
        v:Disable();
    end;
    for _: unknown, v: ConnectionProxy in (getconnections(detection_remote.Destroying)) do
        v:Disable();
    end;

    for _: unknown, v: any in (getgc(false)) do
        if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v)) then
            local constants = debug.getconstants(v);
            if (table.find(constants, "BodyGyro")) then
                hookfunction(v, function(...): ...any  
                    return;
                end);
            end;
        end;
    end;

    local namecall: (...any) -> (...any); namecall = oth.hook(debug.getmetatable(game).__namecall, function(...: any): ...any  
        if (getthreadidentity() ~= 2) then return namecall(...); end;
        local self: Instance = select(1, ...);
        if (typeof(self) == "Instance" and string.lower(getnamecallmethod()) == "fireserver" and self == detection_remote) then
            return;
        end;
        return namecall(...);
    end);

end;
