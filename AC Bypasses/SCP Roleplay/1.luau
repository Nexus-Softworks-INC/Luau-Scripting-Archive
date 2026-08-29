--!strict
--!native

local players = cloneref(game:GetService("Players")) :: Players;
local player = players.LocalPlayer :: Player;

local oth = (oth or {hook = hookfunction}) :: typeof(oth);
local game_metatable = getrawmetatable(game) :: any;

local detection_remote: RemoteFunction = workspace.LoadstringRemote; -- genius
local interact_remote: RemoteEvent = cloneref(game:GetService("ReplicatedStorage")).Remotes.Interact;

for _: unknown, v: ConnectionProxy in (getconnections(game.DescendantAdded)) do
    if (not v.Function or isexecutorclosure(v.Function) or iscclosure(v.Function)) then
        continue;
    end;
    hookfunction(v.Function, function(...: Instance): ...any  
        return;
    end);
end;

for _: unknown, v: (...any) -> (...any) in getgc(false) do
    if (type(v) == "function" and not isexecutorclosure(v) and islclosure(v)) then
        local enviorment:{ [string]: any } = getfenv(v);
        if (enviorment and type(enviorment) == "table" and not rawget(enviorment, "script")) then -- this is rlly bad but its whatever it works for now
            hookfunction(v, function(...: any): ...any 
                return;
            end);
        end;
    end;
end;

do
    local InvokeServer: (self: RemoteFunction, ...any) -> (...any); InvokeServer = oth.hook(Instance.new("RemoteFunction").InvokeServer, function(...: any): ...any 
        if (getthreadidentity() ~= 2) then
            return InvokeServer(...);
        end;

        local self: Instance = select(1, ...);
        if (self and typeof(self) == "Instance" and self.ClassName == "RemoteFunction" and self == detection_remote) then
            return;
        end;

        return InvokeServer(...);
    end);
    
    
    local namecall: (...any) -> (...any); namecall = oth.hook(game_metatable.__namecall, function(...)
        if (getthreadidentity() ~= 2) then
            return namecall(...);
        end;

        local self: Instance, args: {[number]: any} = select(1, ...), {select(2, ...)};
        local method: string = string.lower(getnamecallmethod());

        if (self and typeof(self) == "Instance" and self.ClassName == "RemoteFunction" and self == detection_remote and method == "invokeserver" or self.ClassName == "RemoteEvent" and method == "fireserver" and self == interact_remote and typeof(args[1]) ~= "Instance" or self == player and method == "kick") then
            return;
        end;

        return namecall(...);
    end);
end;

warn("ran bypass");
