local players: Players = game:GetService("Players");
local player = players.LocalPlayer :: Player;

local character_added: (_: unknown) -> () = function(_: unknown): ()
    local alarm = player.PlayerGui:WaitForChild("Alarm") :: ScreenGui;   
    local remote_function: RemoteFunction = alarm:FindFirstChildOfClass("RemoteFunction");

    local callback: (...any) -> (...any) = getcallbackvalue(remote_function, "OnClientInvoke", true);
    if (isfunctionhooked(callback) or isexecutorclosure(callback)) then
        return;
    end;

    --[[local upvalues: {[number]: any} = debug.getupvalues(callback);
    for _: unknown, v: (...any) -> (...any) in upvalues do
        if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v) and not isfunctionhooked(v) and debug.info(v, "n") == "checkFly" or debug.info(v, "n") == "checkSprint" or debug.info(v, "n") == "") then
            hookfunction(v, function(...): ...any 
                return false;
            end);
        end;
    end;]]

    hookfunction(callback, function(...: any): ...any 
        return {false, false, false};
    end);
    remote_function.OnClientInvoke = newlclosure(function(...)
        return {false, false, false};
    end);

    
    return;
end;

player.CharacterAdded:Connect(character_added);
if (player.Character) then
    character_added(player.Character);
end;
