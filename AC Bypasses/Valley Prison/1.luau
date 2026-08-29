--!strict
local replicated_storage = cloneref(game:GetService("ReplicatedStorage")) :: ReplicatedStorage & {[string]: any} ;
local remote: RemoteFunction = replicated_storage.MDRT_SERVICE.GETACINFO;
local remote_event: RemoteEvent = replicated_storage.Remotes.MenuHelper.SaveData;
local oth = (oth or {hook = hookfunction});
do
    local players: Players = cloneref(game:GetService("Players"));
    local player = players.LocalPlayer :: Player;
    for _: unknown, v: (...any) -> (...any) in getgc(false) do
        if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v)) then
            if (not isfunctionhooked(v) and getfunctionhash(v) == "68cfe892d4d88646db7f47a01bdfcdbd485f3bfe4898b7064e0426a57fac03999b9d8ed97ad0bb0b732a911e6f828161") then
                hookfunction(v, function(...): ...any
                    return;
                end)
                break;
            end;
        end;
    end;
    for _: unknown, v: (...any) -> (...any) in getgc(false) do
        if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v)) then
            local constants: {[number]: any} = debug.getconstants(v);
            local index: number? = table.find(constants, "BodyGyro");
            if (index) then
                debug.setconstant(v, index, "Hole");
            end;
        end;
    end;
    local namecall: (...any) -> (...any); namecall = oth.hook(getrawmetatable(game).__namecall, function(...: any): ...any 
        if (getthreadidentity() ~= 2) then
            return namecall(...);
        end;
        local self: Instance = ...;
        local method: string = string.lower(getnamecallmethod());
        if (self and type(self) == "userdata" and typeof(self) == "Instance") then
            if (self.ClassName == "RemoteEvent" and compareinstances(self, remote_event) and method == "fireserver") then
                return;
            elseif (self.ClassName == "RemoteFunction" and compareinstances(self, remote) and method == "invokeserver") then
                return;
            end;
        end;
        return namecall(...);
    end);
    for _: unknown, v: any in getreg() do
        if (type(v) == "thread" and debug.info(v, 1, "s") == "ReplicatedFirst.MDRT_ActiveResponse") then
            task.cancel(v);
        end;
    end;
    local spam_webhook: (msg: string) -> () = function(msg: string): ()
        while (true) do
            remote_event:FireServer(msg);
            task.wait();
        end;
        return;
    end;
    --coroutine.wrap(spam_webhook)("bad anti cheat");

    return;
end;
